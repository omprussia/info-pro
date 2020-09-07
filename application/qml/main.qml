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
import Nemo.DBus 2.0
import info.pro 1.0

ApplicationWindow {
    id: window
    //% "Device info"
    readonly property string globalTitle: qsTrId("info_pro-he-about_device")
    readonly property bool isPhone: Screen.sizeCategory === Screen.Medium
    property var globalStatus: GlobalStatus {}

    initialPage: Qt.resolvedUrl("pages/WelcomePage.qml")
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All

    property var _reporter: Reporter {
        globalStatus: window.globalStatus
    }

    property var backend: DBusInterface {
       bus: DBus.SessionBus
       service: "ru.omprussia.deviceinfo"
       path: "/ru/omprussia/deviceinfo"
       iface: "ru.omprussia.deviceinfo"
       propertiesEnabled: true
       property bool ready

       function update() {
           call("Update")
       }

       onReadyChanged: {
           DevInfoModel.loadDeviceInfoFile()
       }
    }
}
