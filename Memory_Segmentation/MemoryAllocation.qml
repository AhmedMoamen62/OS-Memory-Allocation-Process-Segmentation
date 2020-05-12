import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    id: memory
    property int memSize: 0
    property var memList: []
    signal drawMemory()
    onDrawMemory: {
        memoryRepeater.model = memList
        memoryRepeater.setMemory()
    }
    ScrollView {
        id: chartscroll
        width: 150
        height: parent.height*0.5
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 25
        anchors.rightMargin: 25
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
                    width: 90
                    color: "orange"
                    border.color: "dark red"
                    radius: 10
                    function setWidth()
                    {
                        height = (memory.memList[index].size/memSize)*memory.height*0.6
                    }
                    function setTexts()
                    {
                        textIdLable.text = memory.memList[index].id
                        textAddressStart.text = memory.memList[index].base
                    }
                    Connections {
                        target: memoryRepeater
                        function onWidthAlarm()
                        {
                            memoryRect.setWidth()
                        }
                    }
                    states: [
                        State {
                            name: "faded"
                            PropertyChanges {
                                target: memoryRect
                                color: "gray"
                            }
                        },
                        State {
                            name: "original"
                            PropertyChanges {
                                target: memoryRect
                                color: "orange"
                            }
                        }
                    ]
                    transitions: Transition {
                        ColorAnimation {
                            duration: 500
                        }
                    }
                    Text {
                        id: zeros
                        text: "0"
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
                        font.pixelSize: 18
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
                }
            }
        }
    }
}
