import QtQuick 2.12
import QtQuick.Window 2.12
import "memoryManagementAllocation.js" as Mma

Window {
    id: window
    visible: true
    width: 640
    height: 480
    color: "black"
    minimumHeight: 600
    minimumWidth: 800
    title: qsTr("Memory Segmentation")
    property alias memorySize: holesconfigration.memSize
    property alias processNumber: processconfigration.processNum
    property alias holesList: holesconfigration.listOfholes
    property alias segmentsList: processconfigration.memorySegments
    property alias selectedProcess: processconfigration.currentProcess
    property alias memoryList: memory.memList
    property alias allocateFitting: processconfigration.processFitting
    signal processConfigration()
    signal readPending()
    onReadPending: {
        //Mma.pendingList[0][0]
    }
    onProcessConfigration: {
        holesconfigration.visible = false
        processconfigration.visible = true
        back_rec.visible = true
        memoryList = Mma.initializeMemory(holesList)
        setMemory()
        readPending()
    }
    function setMemory()
    {
        memory.memSize = memorySize
        memory.drawMemory()
        memory.visible = true
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
        onCallAllocation: {
            memoryList = Mma.checkValidity(segmentsList)
            allocateProcess()
            setMemory()
        }
        onCallDeallocation: {
            memoryList = Mma.deallocate(process)
            deallocateProcess()
            setMemory()
            readPending()
        }
    }
    MemoryAllocation {
        id: memory
        visible: false
        anchors.fill: parent
    }
    Rectangle{
        id: memorysize
        color: "black"
        width: 140
        height: 40
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 90
        anchors.bottomMargin: 50
        radius: width/10
        border.color: "orange"
        border.width: 2
        visible: processconfigration.visible ? true : false
        Text {
            anchors.centerIn: parent
            text: "Memory Size: " + memorySize
            font.pixelSize: 14
            color: "orange"
        }
    }
//    Rectangle{
//        id: noofprocess
//        color: "black"
//        width: parent.width/8
//        height: parent.height/15
//        anchors.right: processname.left
//        anchors.verticalCenter: ispreemptive.verticalCenter
//        anchors.rightMargin: 10
//        radius: width/10
//        border.color: "orange"
//        border.width: 2
//        visible: false
//        Text {
//            anchors.centerIn: parent
//            text: "Number of process: " + lastconfigration.processnumber
//            font.pixelSize: parent.width*0.09
//            color: "orange"
//        }
//    }
//    Rectangle{
//        id: ispreemptive
//        color: "black"
//        width: parent.width/8
//        height: parent.height/15
//        anchors.right: parent.right
//        anchors.rightMargin: 20
//        anchors.bottom: scheduling.bottom
//        anchors.bottomMargin: 100
//        radius: width/10
//        border.color: "orange"
//        border.width: 2
//        visible: false
//        Text {
//            anchors.centerIn: parent
//            text: {
//                if(lastconfigration.processtype == "Round Robin")
//                    return "Time Quantum: " + lastconfigration.timeQuantum
//                else if(lastconfigration.ispreemptive)
//                    return "Preemptive"
//                else
//                    return "Non-Preemptive"

//            }
//            font.pixelSize: parent.width*0.1
//            color: "orange"
//        }
//    }
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
