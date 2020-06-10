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
import QtQuick 2.0
import Sailfish.Silica 1.0
import info.pro 1.0

Item {
    id: root
    property alias itemPath: loader.source
    property alias checkStatus: info.status
    property var value
    property var targetValue
    property alias displayedValue: info.value
    property alias displayedTargetValue: info.targetValue
    property bool loaded

    height: info.height + (isPortrait ? 0 : Theme.paddingMedium)
    opacity: checkStatus === CheckStatus.Idle ? Theme.opacityLow : 1.0
    Behavior on opacity { FadeAnimation { } }
    Behavior on height { NumberAnimation { duration: 200 } }

    InfoItem {
        id: info

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: Theme.paddingSmall
            right: parent.right
            rightMargin: Theme.paddingSmall
        }
    }

    Loader {
        id: loader

        onStatusChanged: {
            if (status === Loader.Ready) {
                item.targetValue = targetValue
                item.value = Qt.binding(function() { return value })
                info.name = item.name
                info.value = Qt.binding(function() { return item.displayedValue })
                info.targetValue = Qt.binding(function() { return item.displayedTargetValue })
                info.status = Qt.binding(function() { return item.status })
            }
        }
    }

    Timer {
        id: timerDelayLoaded
        interval: 100
        onTriggered: loaded = true
    }

    onCheckStatusChanged: {
        if (checkStatus !== CheckStatus.Wait)
            timerDelayLoaded.start()
    }
}
