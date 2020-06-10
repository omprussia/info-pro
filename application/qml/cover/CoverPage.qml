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
import QtGraphicalEffects 1.0
import info.pro 1.0

CoverBackground {

    Label {
        anchors {
            bottom: iconStatus.top
            bottomMargin: Theme.paddingLarge
        }
        x: Theme.paddingMedium
        width: parent.width - x * 2
        truncationMode: TruncationMode.Fade
        horizontalAlignment: Text.AlignHCenter
        fontSizeMode: Text.HorizontalFit
        font.pixelSize: Theme.fontSizeExtraLarge
        //% "Info Pro"
        text: qsTrId("info_pro-ap-name")
    }

    Image {
        id: iconStatus

        anchors {
            centerIn: parent
            verticalCenterOffset: - Theme.paddingMedium
        }
        Component.onCompleted: {
            sourceSize.width = sourceSize.width * Theme.pixelRatio
            sourceSize.height = sourceSize.height * Theme.pixelRatio
        }
    }

    Label {
        id: labelStatus
        anchors {
            top: iconStatus.bottom
            topMargin: Theme.paddingLarge
        }
        x: Theme.paddingMedium
        width: parent.width - x * 2
        maximumLineCount: 2
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        font.pixelSize: Theme.fontSizeSmallBase
        truncationMode: TruncationMode.Fade
    }

    states: [
        State {
            when: globalStatus.status === CheckStatus.Wait || globalStatus.status === CheckStatus.Idle
            PropertyChanges { target: iconStatus; source: Qt.resolvedUrl(_graphicsPath.arg("idle")) }
            PropertyChanges { target: labelStatus; text: "" }
        },
        State {
            when: globalStatus.status === CheckStatus.Successful
            PropertyChanges { target: iconStatus; source: Qt.resolvedUrl(_graphicsPath.arg("ok")) }
            PropertyChanges {
                target: labelStatus
                //% "The device matches"
                text: qsTrId("info_pro-la-cover_ok")
            }
        },
        State {
            when: globalStatus.status === CheckStatus.Error
            PropertyChanges { target: iconStatus; source: Qt.resolvedUrl(_graphicsPath.arg("error")) }
            PropertyChanges {
                target: labelStatus
                //% "Device does not match"
                text: qsTrId("info_pro-la-cover_error")
            }
        },
        State {
            when: globalStatus.status === CheckStatus.Unknown
            PropertyChanges { target: iconStatus; source: Qt.resolvedUrl(_graphicsPath.arg("unknown")) }
            PropertyChanges {
                target: labelStatus
                //% "Error"
                text: qsTrId("info_pro-la-cover_unknown")
            }
        }
    ]

    readonly property string _graphicsPath: ("/usr/share/omp-info-pro/graphics/icon-cover-%1.svg")
}
