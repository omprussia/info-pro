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

Item {
    clip: true
    Image {
        x: parent.width * (isPortrait ? 0.3 : 0.5)
        y: parent.height * (isPortrait ? 0.67 : 0.52)

        source: Qt.resolvedUrl("/usr/share/omp-info-pro/graphics/icon-l-gears.svg")

        Component.onCompleted: {
            sourceSize.width = sourceSize.width * Theme.pixelRatio
            sourceSize.height = sourceSize.height * Theme.pixelRatio
        }

        smooth: true
        layer {
            enabled: true
            effect: ColorOverlay {
                color: Theme.rgba(Theme.highlightColor, Theme.highlightBackgroundOpacity)
            }
        }
    }
}
