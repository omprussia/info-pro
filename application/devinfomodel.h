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
#ifndef DEVICEINFOMODEL_H
#define DEVICEINFOMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QFileSystemWatcher>

struct Check;
class QFileInfo;

class DevInfoModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString prettyName READ prettyName WRITE setPrettyName NOTIFY prettyNameChanged)
    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged)
    Q_PROPERTY(QStringList docTypes READ docTypes NOTIFY docTypesChanged)
    Q_PROPERTY(bool availableConfig READ availableConfig NOTIFY availableConfigChanged)

public:
    enum {
        NameRole = Qt::UserRole,
        ItemPathRole,
        TargetValueRole,
        ValueRole
    };

    explicit DevInfoModel(QObject *parent = nullptr);
    ~DevInfoModel();

    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QString path() const;
    QStringList docTypes() const;
    bool availableConfig() const;
    QString prettyName() const;

public slots:
    void setPath(const QString &path);
    void reload();
    QVariant getParam(const QString &key) const;
    void setPrettyName(QString prettyName);
    void loadDeviceInfoFile();

signals:
    void pathChanged(const QString &path);  
    void docTypesChanged(QStringList docTypes);
    void availableConfigChanged(bool availableConfig);
    void prettyNameChanged(QString prettyName);

private:
    void updateChecksList();
    void addCheckItems(const QFileInfo &fileInfo);
    void readDeviceInfo();
    void update();

private:
    QList<Check> m_checks;
    QString m_path;
    QMap<QString, QVariant> m_param;
    QJsonObject m_deviceInfo;
    QString m_prettyName;
    QFileSystemWatcher m_deviceInfoWatcher;

};

#endif // DEVICEINFOMODEL_H
