/****************************************************************************
**
** Copyright (C) 2020 Open Mobile Platform LLC
** Contact: https://community.omprussia.ru/open-source
**
** This file is part of the omp-info-pro.
**
** This code is licensed under the MIT License (MIT).
**
** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
** IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
** FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
** AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
** LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
** OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
** THE SOFTWARE.
**
****************************************************************************/
#include <QGuiApplication>
#include <QQuickView>
#include <QQmlEngine>
#include <QQuickItem>
#include <QtQml>
#include <QSysInfo>
#ifdef HAS_BOOSTER
#include <MDeclarativeCache>
#endif

#include "devinfomodel.h"
#include "checkstatus.h"
#include "unknownstatus.h"
#include "globalstatus.h"
#include "reporter.h"
#include "appdocmodel.h"
#include "appspecmodel.h"
#include "checkinternet.h"

template <typename T>
static QObject *singletonCreate(QQmlEngine *, QJSEngine *)
{
    return new T;
}

Q_DECL_EXPORT int main(int argc, char **argv)
{
    QCoreApplication::setOrganizationName(QStringLiteral("OMP"));
    QCoreApplication::setOrganizationDomain(QStringLiteral("omprussia.ru"));
    QCoreApplication::setApplicationName(QStringLiteral("omp-info-pro"));

    char uri[] = "info.pro";
    qmlRegisterSingletonType<DevInfoModel>(uri, 1, 0, "DevInfoModel", singletonCreate<DevInfoModel>);
    qmlRegisterType<GlobalStatus>(uri, 1, 0, "GlobalStatus");
    qmlRegisterType<Reporter>(uri, 1, 0, "Reporter");
    qmlRegisterUncreatableType<DeclarativeCheckStatus>(uri, 1, 0, "CheckStatus", "");
    qmlRegisterUncreatableType<DeclarativeUnknownStatus>(uri, 1, 0, "UnknownStatus", "");
    qmlRegisterType<AppDocModel>(uri, 1, 0, "AppDocModel");
    qmlRegisterType<AppSpecModel>(uri, 1, 0, "AppSpecModel");
    qmlRegisterType<CheckInternet>(uri, 1, 0, "CheckInternet");

#ifdef HAS_BOOSTER
    QScopedPointer<QGuiApplication> app(MDeclarativeCache::qApplication(argc, argv));
    QScopedPointer<QQuickView> view(MDeclarativeCache::qQuickView());
#else
    QScopedPointer<QGuiApplication> app(new QGuiApplication(argc, argv));
    QScopedPointer<QQuickView> view(new QQuickView);
#endif

    QObject::connect(view->engine(), &QQmlEngine::quit, app.data(), &QGuiApplication::quit);

    QString path;
    if (qApp->arguments().contains("-desktop")) {
        path = qApp->applicationDirPath() + QDir::separator();
    } else {
        path = QString(DEPLOYMENT_PATH);
    }

    QDir dir(path + QStringLiteral("/translations"));

    QScopedPointer<QTranslator> engineeringEnglish(new QTranslator);
    engineeringEnglish->load("omp-info-pro_eng_en", dir.absolutePath());
    qApp->installTranslator(engineeringEnglish.data());
    QScopedPointer<QTranslator> translator(new QTranslator);
    translator->load(QLocale(), "omp-info-pro", "-", dir.absolutePath());
    qApp->installTranslator(translator.data());

    //% "Info Pro"
    view->setTitle(qtTrId("info_pro-ap-name"));
    view->setSource(QUrl::fromLocalFile(path + QLatin1String("main.qml")));
    view->showFullScreen();

    int result = app->exec();

    QVariant var = view->rootObject()->property("_reporter");
    QObject *obj = qvariant_cast<QObject *>(var);
    QMetaObject::invokeMethod(obj, "sendReport");

    return result;
}

