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

Page {
    allowedOrientations: isPhone ? Orientation.PortraitMask : Orientation.All
    showNavigationIndicator: false
    backNavigation: false

    PageHeader {
        id: header
        title: globalTitle
    }

    ColumnLayout {
        anchors {
            fill: parent
            topMargin: header.height + (isPhone ? Theme.paddingSmall : Theme.paddingLarge)
            leftMargin: Theme.horizontalPageMargin
            rightMargin: Theme.horizontalPageMargin
        }

        StatusBar {
            onRepeat: backend.update()
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            ContentView {
                id: content
                anchors {
                    fill: parent
                    topMargin: isPhone ? Theme.paddingMedium : Theme.paddingLarge
                    bottomMargin: topMargin
                }
            }
        }

        NavigationBar {
            Layout.fillWidth: true
            canBack: false
            //% "Installed applications"
            nextText: qsTrId("info_pro-bt-installed_app")
            enabled: true
            onNext: pageStack.push(Qt.resolvedUrl("AppsPage.qml"), { title : nextText , backText: header.title }, PageStackAction.Animated)
        }
    }
}
