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
#include <QtQml>
#include <QTranslator>
#include <QDebug>
#include <QDir>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QQmlEngine>
#include <QQuickItem>
#include "referencefile.h"
#include "../application/checkstatus.h"

namespace {
    const auto CHECKS_PATH = QStringLiteral("/usr/share/omp-info-pro/checks");
    const auto DEVICE_INFO_PATH = QStringLiteral("/usr/share/device-info/deviceinfo.json");
}

struct Check {
    Check() :  order(-1), valid(false)
    {
    }
    bool operator <(const Check &other) const
    {
        return order < other.order;
    }
    QString name;
    QQuickItem *item;
    int order;
    bool valid;
};

ReferenceFile::ReferenceFile(QObject *parent)
    : QObject(parent)
    , m_checks()
    , m_engine(new QQmlEngine(this))
{
    loadCheckItems();
}

ReferenceFile::~ReferenceFile()
{
}

QByteArray ReferenceFile::generate()
{
    QJsonDocument doc;
    QJsonArray arr;

    for (auto item : m_checks) {
        auto value = item.item->property("value");
        QJsonObject objCheck = {
            { "name", item.name },
            { "targetValue", QJsonValue::fromVariant(value) }
        };

        arr.append(objCheck);
    }

    // FIXME: device
    QJsonObject obj = {
        { "checks", arr },
        { "revision", "1" },
        { "device", "" /* device */}
    };

    doc.setObject(obj);

    return doc.toJson();
}

QString ReferenceFile::createFile()
{
    // FIXME: device
    QFile file(QString("device") + ".json");
    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "Don't open file " << file.fileName();
        return {};
    }
    file.write(generate());
    return file.fileName();
}


void ReferenceFile::loadCheckItems()
{
    m_checks.clear();
    QDir directory(CHECKS_PATH);
    directory.setFilter(QDir::Files | QDir::NoSymLinks);
    directory.setNameFilters({"*.qml"});

    for (const auto &jsonFileInfo : directory.entryInfoList()) {
         addCheckItem(jsonFileInfo);
    }
    qSort(m_checks);
}

void ReferenceFile::addCheckItem(const QFileInfo &fileInfo)
{
    auto qmlPath = fileInfo.absoluteFilePath();
    Check checkItem;
    QQmlComponent component(m_engine, qmlPath);
    QObject *object = component.create();
    checkItem.item = qobject_cast<QQuickItem*>(object);
    checkItem.name = fileInfo.baseName();
    checkItem.item->setProperty("targetValue", QVariant(0));
    checkItem.order = checkItem.item->property("order").toInt();
    checkItem.valid = checkItem.item->property("name").isValid();

    while (true) {
        auto status = static_cast<DeclarativeCheckStatus::CheckStatus>(checkItem.item->property("status").toInt());
        if (status != DeclarativeCheckStatus::Wait && status != DeclarativeCheckStatus::Idle) {
            break;
        } else {
            QCoreApplication::processEvents();
        }
    }

    if (checkItem.valid)
        m_checks.append(checkItem);
}
