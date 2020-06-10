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
#ifndef REFERENCEFILE_H
#define REFERENCEFILE_H

#include <QAbstractListModel>

struct Check;
class QTranslator;
class QFileInfo;
class QQmlEngine;
class QQuickItem;

class ReferenceFile : public QObject
{
    Q_OBJECT

public:
    explicit ReferenceFile(QObject *parent = nullptr);
    ~ReferenceFile() override;
    QByteArray generate();
    QString createFile();
    void loadCheckItems();
private:

    void addCheckItem(const QFileInfo &fileInfo);

private:
    QList<Check> m_checks;
    QQmlEngine *m_engine;
};

#endif // REFERENCEFILE_H
