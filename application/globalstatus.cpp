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
#include "globalstatus.h"
#include "checkstatus.h"
#include "unknownstatus.h"
#include <QMetaEnum>

GlobalStatus::GlobalStatus(QObject *parent)
    : QObject(parent)
    , m_generalStatus(DeclarativeCheckStatus::Idle)
    , m_countCheck(0)
    , m_countErrorCheck(0)
{
    updateGeneralStatus();
}

GlobalStatus::~GlobalStatus()
{

}

int GlobalStatus::status() const
{
    return m_generalStatus;
}

int GlobalStatus::countCheck() const
{
    return m_countCheck;
}

int GlobalStatus::countErrorCheck() const
{
    return m_countErrorCheck;
}

QVariant GlobalStatus::valueUnknown() const
{
    for (const auto & item : m_statuses) {
        if (item.status == DeclarativeCheckStatus::Unknown)
            return item.value;
    }
    return {};
}

void GlobalStatus::update(const QString &name, const QVariant &status, const QVariant &value, const QVariant &targetValue)
{
    m_statuses[name].status = status.toInt();
    m_statuses[name].value = value;
    m_statuses[name].targetValue = targetValue;

    updateGeneralStatus();
}

void GlobalStatus::updateGeneralStatus()
{
    bool errorStatus = false;
    bool unknownStatus = false;
    bool waitStatus = false;
    int countNotSuccessful = 0;

    for (auto statusItem : m_statuses) {
        auto status = static_cast<DeclarativeCheckStatus::CheckStatus>(statusItem.status);
        if (status != DeclarativeCheckStatus::Successful) {
            countNotSuccessful++;

            if (status == DeclarativeCheckStatus::Unknown) {
                unknownStatus = true;
            } else if (status == DeclarativeCheckStatus::Wait) {
                waitStatus = true;
            } else {
                errorStatus = true;
            }
        }
    }

    if (waitStatus) {
        setStatus(DeclarativeCheckStatus::Wait);
    }  else if (errorStatus) {
        setStatus(DeclarativeCheckStatus::Error);
    } else if (unknownStatus) {
        setStatus(DeclarativeCheckStatus::Unknown);
        emit valueUnknownChanged(valueUnknown());
    } else if (m_statuses.count()) {
        setStatus(DeclarativeCheckStatus::Successful);
    } else {
        setStatus(DeclarativeCheckStatus::Idle);
    }
    setCountCheck(m_statuses.count());
    setCountErrorCheck(countNotSuccessful);
}

void GlobalStatus::setStatus(int status)
{
    if (m_generalStatus == status)
        return;

    m_generalStatus = status;
    emit statusChanged(m_generalStatus);
}

void GlobalStatus::setCountCheck(int countCheck)
{
    if (m_countCheck == countCheck)
        return;

    m_countCheck = countCheck;
    emit countCheckChanged(m_countCheck);
}

void GlobalStatus::setCountErrorCheck(int countSuccessful)
{
    if (m_countErrorCheck == countSuccessful)
        return;

    m_countErrorCheck = countSuccessful;
    emit countErrorCheckChanged(m_countErrorCheck);
}

void GlobalStatus::clear()
{
    m_statuses.clear();
    updateGeneralStatus();
}

QString GlobalStatus::report() const
{
    QStringList report;
    report << statusToString(status());
    for (auto it = m_statuses.begin(); it != m_statuses.end(); ++it) {
        QString reportItem("%1 (status: %2 value: %3 targteValue: %4)");
        reportItem = reportItem.arg(it.key());
        reportItem = reportItem.arg(statusToString(it->status));

        if (it->status == DeclarativeCheckStatus::Unknown)
            reportItem = reportItem.arg(unknownStatusToString(it->value));
        else
            reportItem = reportItem.arg(it->value.toString());

        reportItem = reportItem.arg(it->targetValue.toString());
        report << reportItem;
    }
    return report.join("\n");
}

QString GlobalStatus::statusToString(int status) const
{
    QMetaEnum metaEnum = QMetaEnum::fromType<DeclarativeCheckStatus::CheckStatus>();
    return metaEnum.valueToKey(status);
}

QString GlobalStatus::unknownStatusToString(const QVariant &value) const
{
    QMetaEnum metaEnum = QMetaEnum::fromType<DeclarativeUnknownStatus::UnknownStatus>();
    auto status = static_cast<int>(qvariant_cast<DeclarativeUnknownStatus::UnknownStatus>(value));
    return metaEnum.valueToKey(status);
}
