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
#include "appspecmodel.h"

#include <QDir>
#include <QFile>
#include <QDebug>
#include "emmconfig.h"

struct AppSpecItem {
    QString name;
    QString version;
};

AppSpecModel::AppSpecModel(QObject *parent) : QAbstractListModel(parent)
{
    loadAppItems();
}

AppSpecModel::~AppSpecModel() { }

int AppSpecModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_appItems.count();
}

QVariant AppSpecModel::data(const QModelIndex &index, int role) const
{
    int row = index.row();
    if (row < 0 || row >= m_appItems.size())
        return {};

    switch (role) {
    case NameRole:
        return m_appItems.at(index.row()).name;
    case VersionRole:
        return m_appItems.at(index.row()).version;
    default:
        return {};
    }
}

QHash<int, QByteArray> AppSpecModel::roleNames() const
{
    static QHash<int, QByteArray> names = { { NameRole, "name" }, { VersionRole, "version" } };
    return names;
}

void AppSpecModel::loadAppItems()
{
    auto appItems = loadAppItemsFromEmmConfig();
    updateAppItems(appItems);
}

QList<AppSpecItem> AppSpecModel::loadAppItemsFromEmmConfig()
{
    QList<AppSpecItem> result;
    QVariant param = EmmConfig::instance()->getParam("package_list");

    if (param.canConvert<QVariantMap>()) {
        auto packageMap = param.toMap();
        for (const auto &name : packageMap.keys()) {
            AppSpecItem item;
            item.name = name;
            result.append(item);
        }
    }

    return result;
}

void AppSpecModel::updateAppItems(const QList<AppSpecItem> &appItems)
{
    beginResetModel();
    m_appItems = appItems;
    endResetModel();
}
