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

BackgroundItem {

    property alias name: appName.text
    property alias icon: appIcon.source
    property alias iconHeight: appIcon.height
    property alias iconWidth: appIcon.width

    height: Math.max(appIcon.height, appName.height)
    enabled: false

    Image {
        id: appIcon
        height: Theme.iconSizeLauncher
        width: Theme.iconSizeLauncher

        anchors {
            left: parent.left
            leftMargin: Theme.paddingLarge
        }
    }

    Label {
        id: appName
        anchors {
            fill: parent
            leftMargin: appIcon.width + (isPhone ? Theme.paddingMedium + Theme.paddingLarge : Theme.paddingLarge * 2)
            rightMargin: isPhone ? Theme.paddingMedium : Theme.paddingLarge * 2
        }
        maximumLineCount: 1
        truncationMode: TruncationMode.Fade
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

}
