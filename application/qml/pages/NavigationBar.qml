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
import QtQuick 2.4
import Sailfish.Silica 1.0
import QtQuick.Layouts 1.1
Item {
    id: navBar

    signal back
    signal next

    property bool exit
    property alias canBack: btBack.visible
    property alias canNext: btNext.visible
    property alias enabledBack: btBack.enabled
    property alias enabledNext: btNext.enabled
    property alias backText: btBack.text
    property alias nextText: btNext.text
    property real backPreferredWidth: Theme.buttonWidthLarge
    property real nextPreferredWidth: Theme.buttonWidthLarge

    height: grid.height + Theme.paddingLarge * 2

    GridLayout {
        id: grid
        anchors.centerIn: parent
        width: parent.width
        columns: isPortrait && isPhone ? 1 : 2
        rowSpacing: Theme.paddingMedium
        property bool isAlignCenter: isPortrait && (!(canBack && canNext) || isPhone)

        Button {
            id: btBack
            Layout.alignment: grid.isAlignCenter ? Qt.AlignHCenter : Qt.AlignLeft
            preferredWidth: isPortrait && isPhone ? parent.width : navBar.backPreferredWidth
            //% "Back"
            text: qsTrId("info_pro-bt-back")
            onClicked: back()
        }
        HighlightedButton {
            id: btNext

            Layout.alignment: grid.isAlignCenter ? Qt.AlignHCenter : Qt.AlignRight
            //% "Next"
            text: qsTrId("info_pro-bt-next")
            onClicked: next()
            preferredWidth: isPortrait && isPhone ? parent.width : navBar.nextPreferredWidth
        }
    }
}
