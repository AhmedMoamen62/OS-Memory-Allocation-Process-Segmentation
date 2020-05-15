import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    id: memory
    property int memSize: 0
    property var memList: []
    signal drawMemory()
    signal deallocateSegment(string process)
    onDrawMemory: {
        memoryRepeater.model = memList
        memoryRepeater.setMemory()
    }
    ScrollView {
        id: chartscroll
        width: 225
        height: parent.height*0.9
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: parent.height*0.05
        anchors.rightMargin: 15
        clip: true
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        Column{
            id: columnId
            anchors.centerIn: parent
            Repeater{
                id: memoryRepeater
                signal widthAlarm()
                function setMemory()
                {
                    for(var i = 0 ; i < model.length; i++)
                    {
                        widthAlarm()
                        itemAt(i).setTexts()
                    }
                }
                Rectangle{
                    id: memoryRect
                    width: 150
                    color: {
                        if(memory.memList[index].id.substr(0,4) === "Hole")
                        {
                            return "blue"
                        }
                        else if(memory.memList[index].id.substr(0,4) === "Rest")
                        {
                            return "red"
                        }
                        else
                        {
                            return "orange"
                        }
                    }
                    border.color: "grey"
                    radius: 3
                    function setWidth()
                    {
                        height = (memory.memList[index].size/memSize)*memory.height
                    }
                    function setTexts()
                    {
                        textIdLable.text = memory.memList[index].Type === "segment" ? memory.memList[index].id + " , " + memory.memList[index].segmentName : memory.memList[index].id
                        textAddressStart.text = index == memory.memList.length - 1 ? memSize : memory.memList[index+1].base
                    }
                    Connections {
                        target: memoryRepeater
                        function onWidthAlarm()
                        {
                            memoryRect.setWidth()
                        }
                    }
                    Text {
                        id: zeros
                        text: memory.memList[index].base
                        color: "orange"
                        font.pixelSize: 16
                        visible: index == 0 ? true : false
                        font.family: "Helvetica"
                        font.bold: true
                        anchors.top: memoryRect.top
                        anchors.left: memoryRect.right
                        anchors.leftMargin: 3
                    }
                    Text {
                        id: textIdLable
                        color: "black"
                        font.pixelSize: 16
                        font.bold: true
                        anchors.centerIn: parent
                    }
                    Text{
                        id: textAddressStart
                        color: "orange"
                        font.pixelSize: 16
                        font.family: "Helvetica"
                        font.bold: true
                        anchors.bottom: memoryRect.bottom
                        anchors.left: memoryRect.right
                        anchors.leftMargin: 3
                    }
                    MouseArea {
                        id: deallocatemouse
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        hoverEnabled: true
                        onEntered: {
                            if(memory.memList[index].Type !== "hole")
                            {
                                parent.color = "grey"
                            }
                        }
                        onExited: {
                            if(memory.memList[index].Type === "segment")
                            {
                                parent.color = "orange"
                            }
                            if(memory.memList[index].Type === "restricted")
                            {
                                parent.color = "red"
                            }
                        }
                        onDoubleClicked: {
                            if(memory.memList[index].Type !== "hole")
                            {
                                deallocateSegment(memory.memList[index].id)
                            }
                        }
                    }
                }
            }
        }
    }
}
