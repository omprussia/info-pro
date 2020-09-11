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
import "private"

BaseCheck {
    //% "SIM card and 3G / 4G module"
    name: qsTrId("info_pro-la-check_sim_card")
    order: 90
    displayedTargetValue: ""
    value: {
        "status": CheckStatus.Idle,
        "unknownStatus": "",
        "value": ""
    }

    property bool online: checkInternet.connected

    status: {
        if (value.status == CheckStatus.Successful) {
            if (!online) {
                if (_wait)
                    return CheckStatus.Wait
                else
                    return CheckStatus.Unknown
            } else {
                return CheckStatus.Successful
            }
        } else {
            return value.status
        }
    }

    displayedValue: {
        if (status === CheckStatus.Successful) {
            return value.value
        } else if (status === CheckStatus.Wait) {
            return ""
        } else {
            switch (value.unknownStatus) {
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
                //% "Turn on mobile internet"
                return qsTrId("info_pro-la-turn_on_mobile_data")
            case UnknownStatus.NoNetwork:
                //% "No network connection"
                return qsTrId("info_pro-la-no_network_connection")
            case UnknownStatus.NoInternet:
                //% "No internet access"
                return qsTrId("info_pro-la-no_internet_connection")
            }
        }
        return ""
    }

    Timer {
        id: connectionTimeout
        interval: 60000
        onTriggered: _wait = false
    }

    Component.onCompleted: {
        connectionTimeout.start()
        checkInternet.check()
    }

    CheckInternet {
        id: checkInternet

        onConnectedChanged: {
            if (connected)
                connectionTimeout.stop()
            _wait = false
        }
    }

    property bool _wait: true
}

