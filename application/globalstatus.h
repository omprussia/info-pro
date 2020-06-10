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
#ifndef GLOBALSTATUS_H
#define GLOBALSTATUS_H

#include <QAbstractListModel>

class GlobalStatus : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int status READ status WRITE setStatus NOTIFY statusChanged)
    Q_PROPERTY(int countCheck READ countCheck WRITE setCountCheck NOTIFY countCheckChanged)
    Q_PROPERTY(int countErrorCheck READ countErrorCheck WRITE setCountErrorCheck NOTIFY countErrorCheckChanged)
    Q_PROPERTY(QString report READ report CONSTANT)
    Q_PROPERTY(QVariant valueUnknown READ valueUnknown NOTIFY valueUnknownChanged)

public:
    struct StatusItem {
        int status;
        QVariant value;
        QVariant targetValue;
        StatusItem() : status(-1) {}
    };

public:
    explicit GlobalStatus(QObject *parent = nullptr);
    ~GlobalStatus();

    int status() const;
    int countCheck() const;
    int countErrorCheck() const; 
    QVariant valueUnknown() const;

public slots:
    void update(const QString &name, const QVariant &status, const QVariant &value, const QVariant &targetValue);
    void updateGeneralStatus();
    void setStatus(int status);
    void setCountCheck(int countCheck);
    void setCountErrorCheck(int countErrorCheck);
    void clear();
    QString report() const;

signals:
    void statusChanged(int status);
    void countCheckChanged(int countCheck);
    void countErrorCheckChanged(int countErrorCheck);
    void valueUnknownChanged(QVariant valueUnknown);

private:
    QString statusToString(int status) const;
    QString unknownStatusToString(const QVariant &value) const;

private:
    int m_generalStatus;
    QMap<QString, StatusItem> m_statuses;
    int m_countCheck;
    int m_countErrorCheck;
};

#endif // GLOBALSTATUS_H
