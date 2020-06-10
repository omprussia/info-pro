.pragma library
function formatAvailable(value) {
    if (value) {
        //% "Available"
        return qsTrId("info_pro-la-available")
    } else {
        //% "Not available"
        return qsTrId("info_pro-la-not_available")
    }
}

function formatPresent(value) {
    if (value) {
        //% "Is present"
        return qsTrId("info_pro-la-is_present")
    } else {
        //% "No present"
        return qsTrId("info_pro-la-no_present")
    }
}

function roundToMbytes(bytes) {
    return Math.round(bytes / 1024 / 1024)
}

function incGbToMbytes(bytes) {
    return bytes + 1024
}


