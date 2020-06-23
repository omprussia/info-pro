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
import QtQuick.Layouts 1.1
import Nemo.DBus 2.0
import info.pro 1.0

RowLayout {
    id: root

    property int status: globalStatus.status
    property bool clickable
    signal repeat

    spacing: 0

    StatusImage {
        Layout.alignment: Qt.AlignTop
        status: globalStatus.status
        size: Theme.iconSizeLarge
    }
    Column {
        Layout.alignment: labelDescription.visible ? Qt.AlignTop : Qt.AlignVCenter
        Layout.fillWidth: true
        BackgroundItem {
            id: clickableArea
            height: labelStatus.height
            width: parent.width
            enabled: clickable && status === CheckStatus.Unknown
            highlightedColor: "transparent"
            InfoLabel {
                id: labelStatus
                property color highlightedColor: palette.secondaryHighlightColor
                property color normalColor: clickableArea.enabled ? Theme.primaryColor : palette.secondaryHighlightColor
                horizontalAlignment: Text.AlignLeft
                x: Theme.paddingMedium
                width: clickableArea.width - x * 2
                color: clickableArea._showPress ? highlightedColor : normalColor
            }
            onClicked: lipstick.openNetworkSelector()
        }

        Label {
            id: labelDescription
            visible: !isPhone && labelStatus.lineCount === 1 && text
            x: Theme.paddingMedium
            width: parent.width - x * 2
            wrapMode: Text.Wrap
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeSmall
        }
    }

    Button {
        Layout.alignment: isPhone && isPortrait ? Qt.AlignVCenter : Qt.AlignTop
        visible: !(isPortrait && isPhone)
        enabled: !repeatLater.running
        preferredWidth: Theme.buttonWidthSmall
        //% "Repeat"
        text: qsTrId("info_pro-bt-repeat")
        onClicked: repeatLater.start()

        Timer {
            id: repeatLater
            interval: 500
            onTriggered: root.repeat()
        }
    }

    states: [
        State {
            when: status === CheckStatus.Wait || itemStatus.status === CheckStatus.Idle
            PropertyChanges {
                target: labelStatus
                //% "Please wait"
                text: qsTrId("info_pro-la-please_wait")
            }
            PropertyChanges { target: labelDescription; text: "" }
        },
        State {
            when: status === CheckStatus.Successful
            PropertyChanges {
                target: labelStatus
                //% "The device matches"
                text: qsTrId("info_pro-la-device_matches")
            }
            PropertyChanges { target: labelDescription; text: "" }
        },
        State {
            when: status === CheckStatus.Error
            PropertyChanges {
                target: labelStatus
                //% "Device does not match"
                text: qsTrId("info_pro-la-device_not_matches")
            }
            PropertyChanges {
                target: labelDescription
                //% "%1 of %2 items do not meet the requirements"
                text: qsTrId("info_pro-la-device_not_matches_desc").arg(globalStatus.countErrorCheck).arg(globalStatus.countCheck)
            }
        },
        State {
            when: status === CheckStatus.Unknown
            PropertyChanges {
                target: labelStatus
                text: _unknownStatusToText(globalStatus.valueUnknown.unknownStatus)
            }
            PropertyChanges { target: labelDescription; text: "" }
        }
    ]

    function _unknownStatusToText(status) {
        switch (status) {
        case UnknownStatus.FlightModeOn:
            //% "Turn off flight mode"
            return qsTrId("info_pro-la-turn_off_flight_mode")
        case UnknownStatus.SimCardNotInstalled:
            //% "SIM card not installed"
            return qsTrId("info_pro-la-sim_card_not_installed")
        case UnknownStatus.WlanOn:
            //% "Turn off Wi-Fi"
            return qsTrId("info_pro-la-turn_off_wifi")
        case UnknownStatus.MobileDataOff:
            //% "Turn on mobile internet in settings"
            return qsTrId("info_pro-la-turn_on_mobile_data_in_settings")
        case UnknownStatus.NoNetwork:
            //% "No network connection"
            return qsTrId("info_pro-la-no_network_connection")
        case UnknownStatus.NoInternet:
            //% "No mobile internet access"
            return qsTrId("info_pro-la-no_mobile_internet_connection")
        }
    }

    DBusInterface {
       id: lipstick
       bus: DBus.SessionBus
       service: "org.nemomobile.lipstick"
       path: "/"
       iface: "com.jolla.lipstick.ConnectionSelectorIf"

       function openNetworkSelector() {
           call("openConnectionNow", ["wifi"])
       }
   }
}
