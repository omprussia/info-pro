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
#include "checkinternet.h"
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QNetworkConfiguration>

static auto REQUEST_ADDRESS = QUrl(QStringLiteral("https://hc.dms.cloud.rt.ru"));
static const int INTERVAL_ONLINE_CHECK = 30 * 1000; // 30 sec

CheckInternet::CheckInternet(QObject *parent)
    : QObject(parent)
    , m_connected(false)
    , m_reply(nullptr)
    , m_wlan(false)
{
    m_checkTimer.setInterval(1000);
    m_checkTimer.setSingleShot(true);
    connect(&m_checkTimer, &QTimer::timeout, this, &CheckInternet::check);
    connect(&m_onlineTimer, &QTimer::timeout, [=] { m_checkTimer.start(); });
    connect(&m_ncm, &QNetworkConfigurationManager::configurationChanged,
            [=](const QNetworkConfiguration &config) {
                if (config.state() == QNetworkConfiguration::Active) {
                    m_checkTimer.start();
                }
            }
    );

    m_onlineTimer.start(INTERVAL_ONLINE_CHECK);
}

CheckInternet::~CheckInternet()
{
    m_onlineTimer.stop();
    m_checkTimer.stop();
}

void CheckInternet::check()
{
    auto networkConfiguration = m_ncm.defaultConfiguration();
    setWlan(networkConfiguration.bearerType() == QNetworkConfiguration::BearerWLAN);
    setConnectName((wlan() ? "WiFi | " : "") + networkConfiguration.name());

    if (m_reply)
        m_reply->abort();

    QNetworkRequest req(REQUEST_ADDRESS);
    auto reply = m_nam.get(req);
    m_reply = reply;

    connect(m_reply, &QNetworkReply::finished, [=] {
        if (reply != m_reply) {
            reply->deleteLater();
            return;
        }

        int statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

        if (reply->error() == QNetworkReply::NoError
            && (statusCode == 200 || statusCode == 204 || statusCode == 301 || statusCode == 302)) {
            setConnected(true);
            qDebug() << "You are connected to the internet :" << statusCode;
        } else {
            setConnected(false);
            qDebug() << "You are not connected to the internet :" << reply->url().toString() << statusCode;
        }
    });

}

bool CheckInternet::connected() const
{
    return m_connected;
}

bool CheckInternet::wlan() const
{
    return m_wlan;
}

QString CheckInternet::connectName() const
{
    return m_connectName;
}

void CheckInternet::setConnected(bool connected)
{
    if (m_connected == connected)
        return;

    m_connected = connected;
    emit connectedChanged(m_connected);
}

void CheckInternet::setConnectName(const QString &connectName)
{
    if (m_connectName == connectName)
        return;

    m_connectName = connectName;
    emit connectNameChanged(m_connectName);
}

void CheckInternet::setWlan(bool wlan)
{
    if (m_wlan == wlan)
        return;

    m_wlan = wlan;
    emit wlanChanged(m_wlan);
}
