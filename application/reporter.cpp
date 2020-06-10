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
#include "reporter.h"
#include <QDebug>
#include "globalstatus.h"
#include "checkstatus.h"
#include <QtDBus>

static const auto DBUS_SERVICE = QStringLiteral("ru.omprussia.deviceinfo");
static const auto DBUS_OBJECT = QStringLiteral("/ru/omprussia/deviceinfo");
static const auto DBUS_IFACE = QStringLiteral("ru.omprussia.deviceinfo");
static const auto DBUS_METHOD_OK = QStringLiteral("SendOkLog");
static const auto DBUS_METHOD_ERROR = QStringLiteral("SendErrorLog");
static const auto DBUS_METHOD_UPDATE = QStringLiteral("Update");


Reporter::Reporter(QObject *parent)
    : QObject(parent)
    , m_globalStatus(nullptr)
{

}

void Reporter::setGlobalStatus(QObject *globalStatus)
{
    if (m_globalStatus == globalStatus)
        return;

    m_globalStatus = qobject_cast<GlobalStatus *>(globalStatus);
    emit globalStatusChanged(m_globalStatus);
}

void Reporter::sendReport()
{
    if (!m_globalStatus)
        return;

    auto report = m_globalStatus->report();

    if (QDBusConnection::systemBus().interface()->isServiceRegistered(DBUS_SERVICE)) {
        if (m_globalStatus->status() == DeclarativeCheckStatus::Successful) {
            QDBusMessage logOkMessage = QDBusMessage::createMethodCall(DBUS_SERVICE, DBUS_OBJECT, DBUS_IFACE, DBUS_METHOD_OK);
            logOkMessage.setArguments({report});
            QDBusReply<void> reply = QDBusConnection::systemBus().call(logOkMessage);

            if (!reply.isValid()) {
                qWarning() << reply.error().message();
            }
        } else {
            QDBusMessage logErrorMessage = QDBusMessage::createMethodCall(DBUS_SERVICE, DBUS_OBJECT, DBUS_IFACE, DBUS_METHOD_ERROR);
            logErrorMessage.setArguments({report});
            QDBusReply<void> reply = QDBusConnection::systemBus().call(logErrorMessage);

            if (!reply.isValid()) {
                qWarning() << reply.error().message();
            }

        }
    } else {
        qDebug() << "report" << report;
    }
}

QObject *Reporter::globalStatus() const
{
    return m_globalStatus;
}
