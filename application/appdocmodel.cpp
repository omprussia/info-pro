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
#include "appdocmodel.h"

#include <QDir>
#include <QFile>
#include <QSettings>
#include <QCoreApplication>
#include <mlite5/MDesktopEntry>

namespace {
const auto USR_SHARE_APP = QStringLiteral("/usr/share/applications");
}

struct AppDocItem {
    QString name;
    QString iconPath;
};

AppDocModel::AppDocModel(QObject *parent)
    : QAbstractListModel(parent)
{
    m_mimeFilters << QStringLiteral("application/msword");
    updateAppItems();
}

AppDocModel::~AppDocModel() { }

int AppDocModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_appItems.count();
}

QVariant AppDocModel::data(const QModelIndex &index, int role) const
{
    int row = index.row();
    if (row < 0 || row >= m_appItems.size())
        return {};

    switch (role) {
    case NameRole:
        return m_appItems.at(index.row()).name;
    case IconRole:
        return m_appItems.at(index.row()).iconPath;
    default:
        return {};
    }
}

QHash<int, QByteArray> AppDocModel::roleNames() const
{
    static QHash<int, QByteArray> names = {
        { NameRole, "name" },
        { IconRole, "icon" }
    };
    return names;
}

QString AppDocModel::getIconPath(const QString &iconName) const
{
    if (iconName.isEmpty()) {
        return {};
    } else if (QFile::exists(iconName)) {
        return iconName;
    } else {
        return QString("image://theme/%1").arg(iconName);
    }
}

void AppDocModel::updateAppItems()
{
    beginResetModel();
    m_appItems.clear();

    QDir desktopDir(USR_SHARE_APP);
    for (const QString &desktop : desktopDir.entryList(QStringList() << "*.desktop", QDir::Files, QDir::NoSort)) {
        MDesktopEntry entry(QString("%1/%2").arg(desktopDir.absolutePath()).arg(desktop));
        if (entry.isValid() && entry.type() == "Application") {
            AppDocItem item;
            item.name = entry.name();
            item.iconPath = getIconPath(entry.icon());
            bool existMimeType = false;

            for (const auto &mimeType : entry.mimeType()) {
                if (existMimeType = m_mimeFilters.contains(mimeType)) {
                    break;
                }
            }

            if (existMimeType)
                m_appItems.append(item);

            QCoreApplication::processEvents();
        }
    }
    endResetModel();
}

void AppDocModel::setMimeFilters(const QStringList &mimeFilters)
{
    if (m_mimeFilters == mimeFilters)
        return;

    m_mimeFilters = mimeFilters;
    updateAppItems();
    emit mimeFiltersChanged(m_mimeFilters);
}

QStringList AppDocModel::mimeFilters() const
{
    return m_mimeFilters;
}
