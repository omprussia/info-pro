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
#include <QJsonDocument>
#include <QJsonObject>
#include "devinfomodel.h"

namespace {
    const auto CHECKS_PATH = QStringLiteral("/usr/share/omp-info-pro/checks");
    const auto DEVICE_INFO_PATH = QStandardPaths::locate(QStandardPaths::TempLocation, "deviceinfo.json");
}

struct Check {
    Check() : valid(false)
    {
    }
    QString name;
    QString itemPath;
    QVariant value;
    QVariant targetValue;
    bool valid;
};

DevInfoModel::DevInfoModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_checks()
    , m_path(CHECKS_PATH)
{
    loadDeviceInfoFile();
}

DevInfoModel::~DevInfoModel()
{
}

QHash<int, QByteArray> DevInfoModel::roleNames() const
{
    static QHash<int, QByteArray> names = {
        {NameRole, "name"},
        {ItemPathRole, "itemPath"},
        {TargetValueRole, "targetValue"},
        {ValueRole, "value"}
    };
    return names;
}

int DevInfoModel::rowCount(const QModelIndex &) const
{
    return m_checks.count();
}

QVariant DevInfoModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() > m_checks.count()) {
        return QVariant();
    }

    switch (role) {
    case NameRole:
        return m_checks.at(index.row()).name;
    case ItemPathRole:
        return m_checks.at(index.row()).itemPath;
    case TargetValueRole:
        return m_checks.at(index.row()).targetValue;
    case ValueRole:
        return m_checks.at(index.row()).value;
    default:
        return {};
    }
}

QString DevInfoModel::path() const
{
    return m_path;
}

QStringList DevInfoModel::docTypes() const
{
    QStringList result;

    for (const auto &docType : m_param.value("docTypes").toList()) {
        result.append(docType.toString());
    }

    return result;
}

bool DevInfoModel::availableConfig() const
{
    return m_checks.count() > 0;
}

QString DevInfoModel::prettyName() const
{
    return m_prettyName;
}


void DevInfoModel::setPath(const QString &path)
{
    if (m_path == path)
        return;

    m_path = path;
    emit pathChanged(m_path);
    updateChecksList();
}

void DevInfoModel::reload()
{
    updateChecksList();
}

QVariant DevInfoModel::getParam(const QString &key) const
{
    return m_param.value(key);
}

void DevInfoModel::setPrettyName(QString prettyName)
{
    if (m_prettyName == prettyName)
        return;

    m_prettyName = prettyName;
    emit prettyNameChanged(m_prettyName);
}

void DevInfoModel::loadDeviceInfoFile()
{
    readDeviceInfo();
    updateChecksList();
    m_deviceInfoWatcher.removePaths(m_deviceInfoWatcher.files());
    m_deviceInfoWatcher.addPath(DEVICE_INFO_PATH);

    connect(&m_deviceInfoWatcher, &QFileSystemWatcher::fileChanged, [=] {
        readDeviceInfo();
        update();
    });
}

void DevInfoModel::updateChecksList()
{
    beginResetModel();
    m_checks.clear();
    m_param.clear();
    QDir directory(path());
    directory.setFilter(QDir::Files | QDir::NoSymLinks);
    directory.setNameFilters({"*.json"});

    for (const auto &jsonFileInfo : directory.entryInfoList()) {
         addCheckItems(jsonFileInfo);
    }

    endResetModel();

    emit availableConfigChanged(availableConfig());
    emit docTypesChanged(docTypes());
}

void DevInfoModel::addCheckItems(const QFileInfo &fileInfo)
{
    auto jsonPath = fileInfo.absoluteFilePath();
    QDir baseDir(fileInfo.absolutePath());

    QFile file(jsonPath);

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Failed to read the device reference information file." << jsonPath;
        return;
    }

    auto doc = QJsonDocument::fromJson(file.readAll());

    auto device = doc.object().value("device");
    if (device != m_deviceInfo.value("device").toString()) {
        qInfo() << "The file with the reference information does not match the device" << jsonPath;
        return;
    }

    auto checks = doc.object().value("checks").toArray();
    auto deviceInfoChecks = m_deviceInfo.value("checks").toArray();

    QMap<QString, QVariant> values;

    for (const auto &check : deviceInfoChecks) {
        auto obj = check.toObject();
        values.insert(obj.value("name").toString(), obj.value("value"));
    }

    for (const auto &check : checks) {
        auto obj = check.toObject();
        Check checkItem;
        checkItem.name = obj.value("name").toString();
        checkItem.itemPath = baseDir.filePath(checkItem.name + ".qml");
        checkItem.targetValue = obj.value("targetValue");
        checkItem.value = values.value(checkItem.name);

        if (!checkItem.itemPath.isEmpty())
            checkItem.valid = true;

        if (checkItem.valid)
            m_checks.append(checkItem);
    }

    for (auto it = doc.object().constBegin(); it != doc.object().constEnd(); ++it) {
        const auto &key = it.key();
        const auto &value = it.value().toVariant();

        if (key != "checks")
            m_param.insert(key, value);
    }
}

void DevInfoModel::readDeviceInfo()
{
    QFile file(DEVICE_INFO_PATH);
    if (!file.open(QIODevice::ReadOnly)) {
        qCritical() << "Can't open the file: " << file.fileName();
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
    m_deviceInfo = doc.object();
    setPrettyName(m_deviceInfo.value("deviceName").toString());
}

void DevInfoModel::update()
{
    auto deviceInfoChecks = m_deviceInfo.value("checks").toArray();
    QMap<QString, QVariant> values;

    for (const auto &check : deviceInfoChecks) {
        auto obj = check.toObject();
        values.insert(obj.value("name").toString(), obj.value("value"));
    }

    for (int i = 0; i < m_checks.count(); i++) {
        auto &check = m_checks[i];
        if (check.value != values.value(check.name)) {
            check.value = values.value(check.name);
            QModelIndex index = createIndex(i, 0);
            emit dataChanged(index, index, { ValueRole });
        }
    }
}
