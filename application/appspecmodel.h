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
#ifndef APPSPECMODEL_H
#define APPSPECMODEL_H

#include <QAbstractListModel>
#include <QVariantList>
struct AppSpecItem;

class AppSpecModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum FileRoles { NameRole = Qt::UserRole, VersionRole };

public:
    explicit AppSpecModel(QObject *parent = nullptr);
    ~AppSpecModel();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    void loadAppItems();

private:
    QList<AppSpecItem> loadAppItemsFromRpm();
    QList<AppSpecItem> loadAppItemsFromEmmConfig();
    void updateAppItems(const QList<AppSpecItem> &appItems);

private:
    QList<AppSpecItem> m_appItems;
};

#endif // APPSPECMODEL_H
