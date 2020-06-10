#include <QDebug>
#include <QDir>
#include <QFile>
#include <QJsonObject>
#include <QJsonDocument>
#include "emmconfig.h"

Q_GLOBAL_STATIC(EmmConfig, emmConfig)

//
// Read all files under this directory and merge them into a parameter map.
// All files in this directory must have json extension an be in JSON format.
//
static const auto CHECKLIST_PARAM_DIR = QStringLiteral("/etc/checklist.d");

EmmConfig::EmmConfig(QObject *parent) : QObject(parent)
{
    QDir dir(CHECKLIST_PARAM_DIR);
    dir.setNameFilters({ "*.json" });

    for (const QString &path : dir.entryList(QDir::Files, QDir::Name)) {
        QFile file(dir.absoluteFilePath(path));

        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            qWarning() << "Can't read checklist param file" << path;
            continue;
        }

        const QJsonDocument doc = QJsonDocument::fromJson(file.readAll());

        if (!doc.isNull()) {
            mergeParam(doc.object());
        }

        file.close();
    }
}

EmmConfig *EmmConfig::instance()
{
    return emmConfig;
}

void EmmConfig::mergeParam(const QJsonObject &obj)
{
    for (auto it = obj.constBegin(); it != obj.constEnd(); ++it) {
        const auto &key = it.key();
        const auto &v = it.value().toVariant();

        if (v.canConvert<QVariantList>()) {
            auto vl = m_param[key].value<QVariantList>();
            vl.append(v.value<QVariantList>());
            m_param[key] = vl;
        } else {
            m_param[key] = v;
        }
    }
}

QVariant EmmConfig::getParam(const QString &key) const
{
    return m_param[key];
}
