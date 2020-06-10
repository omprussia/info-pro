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
import "private/Utils.js" as Utils

BaseCheck {
    //% "NFC"
    name: qsTrId("info_pro-la-check_nfc")
    order: 150
    status: value == targetValue ? CheckStatus.Successful : CheckStatus.Error
    displayedValue: Utils.formatPresent(value)
    displayedTargetValue: Utils.formatAvailable(targetValue)
}

