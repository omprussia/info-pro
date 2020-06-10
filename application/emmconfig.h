#ifndef EMMCONFIG_H
#define EMMCONFIG_H

#include <QObject>
#include <QMap>
#include <QVariant>

class EmmConfig : public QObject
{
    Q_OBJECT
public:
    explicit EmmConfig(QObject *parent = nullptr);
    QVariant getParam(const QString &key) const;
    static EmmConfig *instance();

private:
    void mergeParam(const QJsonObject &obj);

private:
    QMap<QString, QVariant> m_param;
};

#endif // EMMCONFIG_H
