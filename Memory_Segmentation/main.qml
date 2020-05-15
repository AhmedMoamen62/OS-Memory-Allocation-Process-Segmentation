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
    minimumWidth: 1000
    title: qsTr("Memory Segmentation")
    property alias memorySize: holesconfigration.memSize
    property alias processNumber: processconfigration.processNum
    property alias indexProcess: processconfigration.currentProcessIndex
    property alias fittingProcess: processconfigration.fitting
    property alias holesList: holesconfigration.listOfholes
    property alias segmentsList: processconfigration.memorySegments
    property alias selectedProcess: processconfigration.currentProcess
    property alias memoryList: memory.memList
    signal processConfigration()
    onProcessConfigration: {
        holesconfigration.visible = false
        processconfigration.visible = true
        back_rec.visible = true
        memoryList = Mma.initializeMemory(holesList)
        setMemory()
    }
    function setMemory()
    {
        memory.memSize = memorySize
        memory.drawMemory()
        memory.visible = true
    }
    function setProcessesBase()
    {
        // search for each allocated segment in memlist
        for(var i = 0 ; i < memoryList.length ; i++) // i memlist
        {
            // search for each process to get segment base
            for(var j = 0 ; j < processconfigration.processSegmentsData.count ; j++) // j process
            {
                // check if memlist id is same with the process name
                if(processconfigration.processSegmentsData.get(j).Name === memoryList[i].id)
                {
                    // search for each allocated segment in the process
                    for(var h = 0 ; h < processconfigration.processSegmentsData.get(j).Process.count ; h++) // h segment
                    {
                        if(processconfigration.processSegmentsData.get(j).Process.get(h).Segment.SegmentName === memoryList[i].segmentName)
                        {
                            processconfigration.processSegmentsData.get(j).Process.set(h,{"Segment":{"SegmentName":processconfigration.processSegmentsData.get(j).Process.get(h).Segment.SegmentName,
                                                                                               "base":memoryList[i].base,
                                                                                               "size":processconfigration.processSegmentsData.get(j).Process.get(h).Segment.size,
                                                                                               "Initial":processconfigration.processSegmentsData.get(j).Process.get(h).Segment.Initial,
                                                                                               "state":processconfigration.processSegmentsData.get(j).Process.get(h).Segment.state}})
                            break
                        }
                    }
                    break
                }
            }
        }
    }
    function setProcessesState()
    {
        // search for all process states
        for(var i = 0 ; i < processconfigration.processSegmentsData.count ; i++) // process list
        {
            var called = processconfigration.processSegmentsData.get(i).CalledAllocation
            if(called)
            {
                var state = true
                for(var j = 0 ; j < Mma.pendingList.length ; j++) // process pending list
                {
                    // check if pendingList id is same with the process name
                    if(processconfigration.processSegmentsData.get(i).Name === Mma.pendingList[j][0].id)
                    {
                        processconfigration.processSegmentsData.get(i).State = "Pending"
                        processconfigration.setSegmentsState("Pending",i)
                        state = false
                        break
                    }
                }
                if(state)
                {
                    processconfigration.processSegmentsData.get(i).State = "Allocated"
                    processconfigration.setSegmentsState("Allocated",i)
                }
            }
        }
    }
    function convertNameToIndex(name)
    {
        for(var i = 0 ; i < processconfigration.processSegmentsData.count ; i++)
        {
            if(processconfigration.processSegmentsData.get(i).Name === name)
            {
                return i
            }
        }
        return -1
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
            setProcessesBase()
            setProcessesState()
            allocateProcess()
            setMemory()
        }
        onCallDeallocation: {
            memoryList = Mma.deallocate(process)
            setProcessesBase()
            setProcessesState()
            deallocateProcess(convertNameToIndex(process))
            setMemory()
        }
    }
    MemoryAllocation {
        id: memory
        visible: false
        anchors.fill: parent
        onDeallocateSegment: {
            memoryList = Mma.deallocate(process)
            setProcessesBase()
            setProcessesState()
            processconfigration.deallocateProcess(convertNameToIndex(process))
            setMemory()
        }
    }
    Rectangle{
        id: memorysize
        color: "black"
        width: 140
        height: 40
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 90
        anchors.bottomMargin: parent.height/30
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
    Rectangle{
        id: processfitting
        color: "black"
        width: 140
        height: 40
        anchors.left: memorysize.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: parent.width*0.02
        anchors.bottomMargin: parent.height/30
        radius: width/10
        border.color: "orange"
        border.width: 2
        visible: processconfigration.segConfigVisibility ? true : false
        Text {
            anchors.centerIn: parent
            text: {
                if(fittingProcess == "firstfit")
                {
                    return selectedProcess + ": First Fit"
                }
                else
                {
                    return selectedProcess + ": Best Fit"
                }
            }
            font.pixelSize: 14
            color: "orange"
        }
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
                    holesconfigration.initializeDefaultConfigration()
                    processconfigration.generateProcessConfigration()
                }
            }
        }
    }
}
