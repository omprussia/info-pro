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

Page {
    allowedOrientations: isPhone ? Orientation.PortraitMask : Orientation.All
    showNavigationIndicator: false

    PageHeader {
        title: globalTitle
    }

    Column {
        spacing: Theme.paddingLarge * 2
        anchors {
            centerIn: parent
        }

        width: isPhone ? parent.width - Theme.horizontalPageMargin * 2 : Screen.width - Theme.horizontalPageMargin * 4
        Column {
            width: parent.width
            spacing: Theme.paddingSmall

            InfoLabel {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                color: DevInfoModel.availableConfig ? Theme.highlightColor : Theme.errorColor
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                visible: !busyIndicator.visible
                text: DevInfoModel.availableConfig
                      //% "Welcome!"
                      ? qsTrId("info_pro-le-welcom")
                      //% "Your device is not supported."
                      : qsTrId("info_pro-le-device_not_support")
                opacity: visible ? 1.0 : 0.0
                Behavior on opacity { FadeAnimation {} }
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: DevInfoModel.availableConfig
                width: parent.width
                color: Theme.highlightColor
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                //% "The application is designed to obtain information about the characteristics of the device"
                text: qsTrId("info_pro-le-welcom_description") + " " + DevInfoModel.prettyName
                opacity: visible ? 1.0 : 0.0
                Behavior on opacity { FadeAnimation {} }
            }
        }

        BusyIndicator {
            id: busyIndicator
            anchors.horizontalCenter: parent.horizontalCenter
            running: !DevInfoModel.availableConfig
            visible: running
            size: BusyIndicatorSize.Large
        }

        Timer {
            running: !DevInfoModel.availableConfig
            interval: 2000
            onTriggered: busyIndicator.running = false
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: DevInfoModel.availableConfig
            width: parent.width
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            //% "For information, click button"
            text: qsTrId("info_pro-le-welcom_recommendation")
            opacity: visible ? 1.0 : 0.0
            Behavior on opacity { FadeAnimation {} }
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            preferredWidth: Theme.buttonWidthMedium
            visible: DevInfoModel.availableConfig
            //% "Start"
            text: qsTrId("info_pro-bt-start")
            onClicked: pageStack.push(Qt.resolvedUrl("ChecksPage.qml"), {}, PageStackAction.Animated)
            opacity: visible ? 1.0 : 0.0
            Behavior on opacity { FadeAnimation {} }
        }
    }
    GearsBackground {
        anchors.fill: parent
        z: -1
        visible: !isPhone
    }

    Component.onCompleted: backend.update()
}
