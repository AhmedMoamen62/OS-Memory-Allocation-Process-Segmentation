import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    visible: true
    width: 640
    height: 480
    color: "black"
    minimumHeight: 600
    minimumWidth: 800
    title: qsTr("Memory Segmentation")
    signal processConfigration()
    onProcessConfigration: {
        holesconfigration.visible = false
        processconfigration.visible = true
    }
    HolesConfigration {
        id: holesconfigration
        anchors.fill: parent
        onHolesConfigrationFinished: {
            processConfigration()
        }
    }
    ProcessConfigration {
        id: processconfigration
        visible: false
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: parent.height/15
        anchors.leftMargin: parent.width/15
    }
}
