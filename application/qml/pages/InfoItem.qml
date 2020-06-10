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

Column {
    property alias name: labelName.text
    property string value
    property alias targetValue: labelTargetValue.text
    property alias status: iconStatus.status

    Item {
        width: parent.width
        height: Math.max(iconStatus.height, labelName.height + labelName.halfHeightText)
                        + grid.height

        StatusImage {
            id: iconStatus
            anchors.top: parent.top
            size: Theme.iconSizeSmallPlus
        }

        Label {
            id: labelName
            property real halfHeightText: implicitHeight / lineCount / 2
            anchors {
                top: iconStatus.verticalCenter
                topMargin: -halfHeightText
                left: iconStatus.right
                right: parent.right
                rightMargin: leftMargin
            }
            font.pixelSize: Theme.fontSizeSmall
            truncationMode: TruncationMode.Fade
            color: Theme.highlightColor
            maximumLineCount: isPhone ? 1 : 2
            wrapMode: Text.WordWrap
        }

        Grid {
            id: grid
            anchors {
                top: labelName.bottom
                left: labelName.left
                right: labelName.right
            }
            columns: (labelValue.implicitWidth + labelTargetValue.implicitWidth) > width ? 1 : 2
            Label {
                id: labelValue
                text: value + (labelTargetValue.text ?  " / " : "")
                truncationMode: TruncationMode.Fade
                color: Theme.primaryColor
                visible: text || status === CheckStatus.Idle || status === CheckStatus.Wait
                width: Math.min(implicitWidth, Math.max(parent.width, 0))
                font.pixelSize: Theme.fontSizeSmall
                maximumLineCount: labelTargetValue.visible ? 1 : 2
                wrapMode: labelTargetValue.visible ? Text.NoWrap : Text.Wrap
                Behavior on width { NumberAnimation { duration: 50 } }
            }
            Label {
                id: labelTargetValue
                height: labelValue.height
                verticalAlignment: Text.AlignVCenter
                truncationMode: TruncationMode.Fade
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                visible: text || status === CheckStatus.Idle || status === CheckStatus.Wait
                width: Math.min(implicitWidth, Math.max(parent.width, 0))
                Behavior on width { NumberAnimation { duration: 50 } }
            }
        }
    }
}
