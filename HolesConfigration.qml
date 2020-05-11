import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.3
import "deallocation.js" as Ut1
import "memoryManagementAllocation.js" as Mma


Item {
    id: item
    property int memSize: 0
    property int holesNum: 0
    property var listOfholes : []
    property var holes: ({type: 'None',id: 'None',processName: 'None',base: 0,size: 0})
    signal start()
    onStart: {
        console.log('All is done !')
    }
    function isInt(n){
        return Number(n) === n && n % 1 === 0 && Number(n) !== 0;
    }
    ListModel {
        id: holeslist
    }
    GridLayout {
        id: basicsconfigration
        columns: 3
        rows: 3
        columnSpacing: 20
        rowSpacing: 10
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: parent.height*0.075
        anchors.leftMargin: parent.width*0.1
        Text {
            text: "Memory Size: "
            font.bold: true
            font.family: "Comic Sans MS"
            Layout.row: 0
            Layout.column: 0
            color: "orange"
        }
        Text {
            text: "Numbers of holes: "
            font.bold: true
            font.family: "Comic Sans MS"
            Layout.row: 1
            Layout.column: 0
            color: "orange"
        }
        Text {
            id: wrongmemsize
            text: "Please enter an +ve integer memory size !"
            font.bold: true
            font.family: "Comic Sans MS"
            Layout.row: 0
            Layout.column: 2
            color: "orange"
            visible: false
        }
        CustomizingTextField {
            id: memorysize
            placeholderText: "Enter +ve size"
            Layout.column: 1
            Layout.row: 0
        }
        CustomizingSpinBox {
            id: holesnumber
            from: 1
            Layout.column: 1
            Layout.row: 1
        }
        CustomizingButton {
            id: submitbasics
            text: "Submit"
            Layout.column: 0
            Layout.row: 2
            onClicked: {
                Mma.initializeMemory();
                Mma.checkValidity();
                if(isInt(Number(memorysize.text)))
                {
                    wrongmemsize.visible = false
                    holeslist.clear()
                    memSize = Number(memorysize.text)
                    holesNum = holesnumber.value
                    for(var i = 0 ; i < holesNum ; i++)
                    {
                        holeslist.append({"name":"Hole "+(i+1)})
                    }
                    holesconfigration.visible = true
                    submitconfigrations.visible = true
                    holes_table.visible = true
                    holesdata.initialzieList(holesNum)
                }
                else
                {
                    wrongmemsize.visible = true
                }
            }
        }
    }
    GridLayout {
        id: holesconfigration
        columns: 3
        rows: 4
        columnSpacing: 20
        rowSpacing: 10
        anchors.top: basicsconfigration.bottom
        anchors.topMargin: 20
        anchors.left: basicsconfigration.left
        visible: false
        Text {
            text: "Hole No. : "
            font.bold: true
            font.family: "Comic Sans MS"
            Layout.row: 0
            Layout.column: 0
            color: "orange"
        }
        Text {
            text: "Base : "
            font.bold: true
            font.family: "Comic Sans MS"
            Layout.row: 1
            Layout.column: 0
            color: "orange"
        }
        Text {
            text: "Size : "
            font.bold: true
            font.family: "Comic Sans MS"
            Layout.row: 2
            Layout.column: 0
            color: "orange"
        }
        Text {
            id: holeselection
            text: "Please select a hole !"
            font.bold: true
            font.family: "Comic Sans MS"
            Layout.row: 0
            Layout.column: 2
            color: "orange"
            visible: false
        }
        Text {
            id: wrongholebase
            text: "Please enter an +ve integer hole base !"
            font.bold: true
            font.family: "Comic Sans MS"
            Layout.row: 1
            Layout.column: 2
            color: "orange"
            visible: false
        }
        Text {
            id: wrongholesize
            text: "Please enter an +ve integer hole size !"
            font.bold: true
            font.family: "Comic Sans MS"
            Layout.row: 2
            Layout.column: 2
            color: "orange"
            visible: false
        }
        CustomizingComboBox {
            id: holenumbers
            model: holeslist
            Layout.column: 1
            Layout.row: 0
            focus: true
        }
        CustomizingTextField {
            id: holebase
            placeholderText: "Enter +ve base"
            Layout.column: 1
            Layout.row: 1
            focus: true
        }
        CustomizingTextField {
            id: holesize
            placeholderText: "Enter +ve size"
            Layout.column: 1
            Layout.row: 2
            focus: true
        }
        CustomizingButton {
            id: submithole
            text: "Submit Hole"
            Layout.column: 0
            Layout.row: 3
            onClicked: {
                if(holenumbers.currentIndex != -1 && isInt(Number(holebase.text)) && isInt(Number(holesize.text)))
                {
                    holeselection.visible = false
                    wrongholebase.visible = false
                    wrongholesize.visible = false
                    holes.type = "HOLE"
                    holes.id = holenumbers.currentText
                    holes.base = Number(holebase.text)
                    holes.size = Number(holesize.text)
                    listOfholes[holenumbers.currentIndex] = holes
                    holesdata.set(holenumbers.currentIndex,{"HolesName":holenumbers.currentText,
                                        "base":holes.base,
                                        "size":holes.size,
                                        "Initial":"Inialized"})
                }
                if(holenumbers.currentIndex == -1)
                {
                    holeselection.visible = true
                    wrongholebase.visible = !isInt(Number(holebase.text))
                    wrongholesize.visible = !isInt(Number(holesize.text))
                }
                if(!isInt(Number(holebase.text)))
                {
                    wrongholebase.visible = true
                    holeselection.visible = holenumbers.currentIndex == -1 ? true : false
                    wrongholesize.visible = !isInt(Number(holesize.text))
                }
                if(!isInt(Number(holesize.text)))
                {
                    wrongholesize.visible = true
                    holeselection.visible = holenumbers.currentIndex == -1 ? true : false
                    wrongholebase.visible = !isInt(Number(holebase.text))
                }
            }
        }
    }
    ListModel {
        id: holesdata
        function initialzieList(length)
        {
            for(var i = 0 ;i < length ; i++)
            {
                holesdata.append({"HolesName":"Hole "+(i+1),
                                       "base":0,
                                       "size":0,
                                       "Initial":"Not Inialized"})
            }
        }
    }
    TableView {
        id: holes_table
        width: parent.width/2.5
        height: parent.height*0.4
        anchors.top: holesconfigration.bottom
        anchors.left: holesconfigration.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height*0.025
        anchors.topMargin: 20
        focus: true
        model: holesdata
        visible: false
        rowDelegate: Rectangle {
            height: textrow.implicitHeight * 1.2
            width: textrow.implicitWidth
            color: {
                if(styleData.row < holesNum && holesdata.get(styleData.row).Initial === "Inialized")
                {
                    return "gray"
                }
                else
                {
                    return "orange"
                }
            }
            border.color: "black"
            Text {
                id: textrow
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: styleData.textAlignment
                anchors.leftMargin: 12
                elide: Text.ElideRight
                color: "black"
                renderType: Text.NativeRendering
            }
            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 1
                anchors.topMargin: 1
                width: 1
                color: "orange"
            }
        }
        headerDelegate: Rectangle {
            height: textItem.implicitHeight * 1.2
            width: textItem.implicitWidth
            color: "black"
            border.color: "orange"
            Text {
                id: textItem
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: styleData.textAlignment
                anchors.leftMargin: 12
                text: styleData.value
                elide: Text.ElideRight
                color: "orange"
                renderType: Text.NativeRendering
            }
            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 1
                anchors.topMargin: 1
                width: 1
                color: "black"
            }
        }
        TableViewColumn {
            role: "HolesName"
            title: "Holes"
        }
        TableViewColumn{
            role: "base"
            title: "Base"
        }
        TableViewColumn{
            role: "size"
            title: "Size"
        }
        TableViewColumn{
            role: "Initial"
            title: "Initialization"
        }
    }
    MessageDialog {
        id: holesnotfinished
        title: "Holes Initialization"
        text: "Not All Holes are initialized or there is a wrong base or size, Please check and initialize them"
        icon: StandardIcon.Information
        standardButtons: StandardButton.Ok
    }
    CustomizingButton {
        id: submitconfigrations
        text: "Submit Configrations"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 30
        anchors.rightMargin: 30
        visible: false
        onClicked: {
            ////
            Ut1.deallocate("rest1")
            Ut1.deallocate("p1")
            ////
            for(var i = 0 ; i < holesNum; i++)
            {
                if(holesdata.get(i).Initial === "Not Inialized")
                {
                    holesnotfinished.open()
                    break
                }
                if(i === holesdata.count - 1)
                {
                    start()
                }
            }
        }
    }
}
