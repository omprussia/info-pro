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
    id: itemStatus

    property int status: CheckStatus.Idle
    property int size: Theme.iconSizeMedium

    height: size
    width: size

    Image {
        id: iconStatus
        anchors.centerIn: parent
        opacity: iconStatus.source != "" ? 1.0 : 0.0
        sourceSize.height: parent.height
        sourceSize.width: parent.width

        Behavior on opacity { FadeAnimation { } }
    }

    BusyIndicator {
        anchors.centerIn: parent
        size: BusyIndicatorSize.Medium
        opacity: iconStatus.source == "" ? 1.0 : 0.0
        running: opacity > 0
        scale: parent.height/implicitHeight * 0.7
        Behavior on opacity { FadeAnimation { } }
    }
    property string _iconLagePrefix: size > Theme.iconSizeMedium ? "l" : "m"
    property string _graphicsPath: ("/usr/share/omp-info-pro/graphics/icon-%1-%2.svg").arg(_iconLagePrefix)

    states: [
        State {
            when: itemStatus.status === CheckStatus.Wait || itemStatus.status === CheckStatus.Idle
            PropertyChanges { target: iconStatus; source: "" }
        },
        State {
            when: itemStatus.status === CheckStatus.Successful
            PropertyChanges { target: iconStatus; source: Qt.resolvedUrl(_graphicsPath.arg("ok")) }
        },
        State {
            when: itemStatus.status === CheckStatus.Error
            PropertyChanges { target: iconStatus; source: Qt.resolvedUrl(_graphicsPath.arg("error")) }
        },
        State {
            when: itemStatus.status === CheckStatus.Unknown
            PropertyChanges { target: iconStatus; source: Qt.resolvedUrl(_graphicsPath.arg("unknown")) }
        }
    ]
}
