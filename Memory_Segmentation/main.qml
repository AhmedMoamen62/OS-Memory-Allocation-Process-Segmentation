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
        back_rec.visible = true
        memory.memList.push({id: "seg 1",size: 20,startaddress: 20})
        memory.memList.push({id: "hole 1",size: 40,startaddress: 60})
        memory.memList.push({id: "seg 2",size: 20,startaddress: 80})
        memory.drawMemory()
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
        anchors.fill: parent
    }
    MemoryAllocation {
        id: memory
        anchors.fill: parent
    }
    Rectangle {
        id: back_rec
        height: 30
        width: 30
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.topMargin: 10
        color: "gray"
        radius: width/5
        visible: false
        Text {
            id: back_text
            anchors.left: parent.right
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            color: "orange"
            text: "Back"
            font.pixelSize: parent.height * 0.4
            font.family: "Comic Sans MS"
        }
        Image {
            id: back
            source: "images/icons/back.png"
            anchors.centerIn: parent
            mipmap: true
            scale: 0.04
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                hoverEnabled: true
                onEntered: {
                    back_rec.color = "orange"
                    back_text.color = "gray"
                }
                onExited: {
                    back_rec.color = "gray"
                    back_text.color = "orange"
                }
                onClicked: {
                    processconfigration.visible = false
                    memory.visible = false
                    back_rec.visible = false
                    holesconfigration.visible = true
                    processconfigration.generateProcessConfigration()
                }
            }
        }
    }
}
