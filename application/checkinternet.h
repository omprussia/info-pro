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
#ifndef CHECKINTERNET_H
#define CHECKLISTINTERNET_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkConfigurationManager>
#include <QTimer>

class CheckInternet : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
    Q_PROPERTY(bool wlan READ wlan NOTIFY wlanChanged)
    Q_PROPERTY(QString connectName READ connectName NOTIFY connectNameChanged)

public:
    explicit CheckInternet(QObject *parent = nullptr);
    ~CheckInternet();

    Q_INVOKABLE void check();
    bool connected() const;
    bool wlan() const;
    QString connectName() const;

signals:
    void connectedChanged(bool connected);
    void wlanChanged(bool wlan);
    void connectNameChanged(const QString &connectName);

private:
    void setConnected(bool connected);
    void setConnectName(const QString &connectName);
    void setWlan(bool wlan);
private:
    bool m_connected;
    QNetworkAccessManager m_nam;
    QNetworkConfigurationManager m_ncm;
    QNetworkReply *m_reply;
    bool m_wlan;
    QString m_connectName;
    QTimer m_checkTimer;
    QTimer m_onlineTimer;
};

#endif // CHECKINTERNET_H


