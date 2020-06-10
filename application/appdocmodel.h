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
#ifndef APPDOCMODEL_H
#define APPDOCMODEL_H

#include <QAbstractListModel>
#include <QVariantList>
struct AppDocItem;

class AppDocModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QStringList mimeFilters READ mimeFilters WRITE setMimeFilters NOTIFY mimeFiltersChanged)

public:
    enum FileRoles {
        NameRole = Qt::UserRole,
        IconRole
    };

public:
    explicit AppDocModel(QObject *parent = nullptr);
    ~AppDocModel();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    QStringList mimeFilters() const;

public slots:
    void setMimeFilters(const QStringList &mimeFilters);

signals:
    void mimeFiltersChanged(const QStringList &mimeFilters);

private:
    void updateAppItems();
    QString getIconPath(const QString &iconName) const;

private:
    QList<AppDocItem> m_appItems;
    QStringList m_mimeFilters;
};

#endif // APPDOCMODEL_H
