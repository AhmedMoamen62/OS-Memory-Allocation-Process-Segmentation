import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.3
import QtQml.Models 2.14

Item {
    id: item
    property int processNum: 0
    property int segmentNum: 0
    property bool firstFit: true
    property ListModel processSegmentsData: ListModel {
    }
    property var segments: ({Type: 'None',id: 'None',segmentName: 'None',state: "",algorithmType: "First Fit",base: 0,size: 0})
    function isInt(n){
        return Number(n) === n && n % 1 === 0 && Number(n) !== 0;
    }
    ListModel {
        id: processlist
    }
    ListModel {
        id: segmentsname
    }
    ListModel {
        id: segmentdata
    }
    GridLayout {
        id: basicsconfigration
        columns: 2
        rows: 4
        columnSpacing: 5
        rowSpacing: 5
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: parent.height/25
        anchors.leftMargin: parent.width/15
        Text {
            id: segmenttext
            text: "Segments Number:"
            font.bold: true
            font.family: "Comic Sans MS"
            Layout.row: 1
            Layout.column: 0
            color: "orange"
            visible: false
        }
        CustomizingSpinBox {
            id: segmentnumber
            from: 1
            Layout.column: 1
            Layout.row: 1
            visible: false
        }
        CustomizingRadioButton {
            id: firstfit
            text: "First Fit"
            Layout.column: 0
            Layout.row: 2
            checked: true
            visible: false
        }
        CustomizingRadioButton {
            id: bestfit
            text: "Best Fit"
            Layout.column: 1
            Layout.row: 2
            visible: false
        }
        CustomizingButton {
            id: addprocess
            text: "+ Add Process"
            Layout.column: 0
            Layout.row: 0
            onClicked: {
                segmentsconfigration.visible = false
                segmentnumber.visible = true
                segmenttext.visible = true
                sumbitsegmentNumber.visible = true
                firstfit.visible = true
                bestfit.visible = true
            }
        }
        CustomizingButton {
            id: sumbitsegmentNumber
            text: "Submit"
            Layout.column: 0
            Layout.row: 3
            visible: false
            onClicked: {
                var segmentsDataList = {"SegmentName": "None", "base":0, "size": 0, "Initial": "Not Initialized"}
                segmentsname.clear()
                segmentdata.clear()
                segmentNum = segmentnumber.value
                for(var j = 0 ;j < segmentNum ; j++)
                {
                    segmentdata.append({"SegmentName":"Seg "+(j+1),
                                           "base":0,
                                           "size":0,
                                           "Initial":"Not Initialized"})
                }
                processNum++
                firstFit = firstfit.checked
                processlist.append({"name":"P"+processNum})
                processSegmentsData.append({"Process":[]})
                for(var i = 0 ; i < segmentNum ; i++)
                {
                    segmentsname.append({"name":"Seg "+(i+1)})
                    segmentsDataList.SegmentName = segmentdata.get(i).SegmentName
                    segmentsDataList.base = segmentdata.get(i).base
                    segmentsDataList.size = segmentdata.get(i).size
                    segmentsDataList.Initial = segmentdata.get(i).Initial
                    processSegmentsData.get(processNum - 1).Process.append({"Segment":{"SegmentName":segmentsDataList.SegmentName,
                                                                                       "base":segmentsDataList.base,
                                                                                       "size":segmentsDataList.size,
                                                                                       "Initial":segmentsDataList.Initial}})
                }
                currentprocess.currentIndex = processNum - 1
                segmentsconfigration.visible = true
            }
        }
    }
    GridLayout {
        id: segmentsconfigration
        columns: 3
        rows: 6
        columnSpacing: 5
        rowSpacing: 5
        anchors.top: basicsconfigration.bottom
        anchors.left: basicsconfigration.left
        anchors.topMargin: 10
        visible: false
        Text {
            text: "(Optional)"
            font.family: "Comic Sans MS"
            Layout.row: 2
            Layout.column: 2
            color: "orange"
        }
        Text {
            text: "Current Process:"
            font.bold: true
            font.family: "Comic Sans MS"
            Layout.row: 0
            Layout.column: 0
            color: "orange"
        }
        Text {
            text: "Segment No. :"
            font.bold: true
            font.family: "Comic Sans MS"
            Layout.row: 1
            Layout.column: 0
            color: "orange"
        }
        Text {
            text: "Segment Name:"
            font.bold: true
            font.family: "Comic Sans MS"
            Layout.row: 2
            Layout.column: 0
            color: "orange"
        }
        Text {
            text: "Segment Base:"
            font.bold: true
            font.family: "Comic Sans MS"
            Layout.row: 3
            Layout.column: 0
            color: "orange"
        }
        Text {
            text: "Segment Size:"
            font.bold: true
            font.family: "Comic Sans MS"
            Layout.row: 4
            Layout.column: 0
            color: "orange"
        }
        Text {
            id: processselection
            text: "Please select a process !"
            font.family: "Comic Sans MS"
            Layout.row: 0
            Layout.column: 2
            color: "orange"
            visible: false
        }
        Text {
            id: segmentselection
            text: "Please select a segment !"
            font.family: "Comic Sans MS"
            Layout.row: 1
            Layout.column: 2
            color: "orange"
            visible: false
        }
        Text {
            id: wrongsegbase
            text: "Please enter a +ve int segment base !"
            font.family: "Comic Sans MS"
            Layout.row: 3
            Layout.column: 2
            color: "orange"
            visible: false
        }
        Text {
            id: wrongsegsize
            text: "Please enter a +ve int segment size !"
            font.family: "Comic Sans MS"
            Layout.row: 4
            Layout.column: 2
            color: "orange"
            visible: false
        }
        CustomizingComboBox {
            id: currentprocess
            model: processlist
            Layout.column: 1
            Layout.row: 0
            focus: true
            onCurrentIndexChanged: {
                segmentdata.clear()
                segmentsname.clear()
                for(var i = 0 ; i < processSegmentsData.get(currentIndex).Process.count ; i++)
                {
                    segmentsname.append({"name":processSegmentsData.get(currentIndex).Process.get(i).Segment.SegmentName})
                    segmentdata.append({"SegmentName":processSegmentsData.get(currentIndex).Process.get(i).Segment.SegmentName,
                                           "base":processSegmentsData.get(currentIndex).Process.get(i).Segment.size,
                                           "size":processSegmentsData.get(currentIndex).Process.get(i).Segment.base,
                                           "Initial":processSegmentsData.get(currentIndex).Process.get(i).Segment.Initial})
                }
            }
        }
        CustomizingComboBox {
            id: segmentnum
            model: segmentsname
            Layout.column: 1
            Layout.row: 1
            focus: true
        }
        CustomizingTextField {
            id: segmentname
            placeholderText: "Enter Seg Name"
            Layout.column: 1
            Layout.row: 2
        }
        CustomizingTextField {
            id: segmentbase
            placeholderText: "Enter Seg Base"
            Layout.column: 1
            Layout.row: 3
        }
        CustomizingTextField {
            id: segmentsize
            placeholderText: "Enter Seg Size"
            Layout.column: 1
            Layout.row: 4
        }
        CustomizingButton {
            id: submitsegment
            text: "Submit Segment"
            Layout.column: 0
            Layout.row: 5
            onClicked: {
                if(segmentnum.currentIndex != -1 && currentprocess.currentIndex != - 1 && isInt(Number(segmentbase.text)) && isInt(Number(segmentsize.text)))
                {
                    processselection.visible = false
                    segmentselection.visible = false
                    wrongsegbase.visible = false
                    wrongsegsize.visible = false
                    segments.Type = "PROCESS"
                    segments.id = "P" + processNum
                    segments.segmentName = Number(segmentname.text) !== 0 ? segmentname.text : segmentsname.get(segmentnum.currentIndex).name
                    segments.base = Number(segmentbase.text)
                    segments.size = Number(segmentsize.text)
                    segments.algorithmType = firstFit ? "Best Fit" : "First Fit"
                    segmentdata.set(segmentnum.currentIndex,{"SegmentName":segments.segmentName,
                                        "base":segments.base,
                                        "size":segments.size,
                                        "Initial":"Initialized"})
                    processSegmentsData.get(currentprocess.currentIndex).Process.set(segmentnum.currentIndex,{"Segment":{"SegmentName":segments.segmentName,
                                                                                       "base":segments.base,
                                                                                       "size":segments.size,
                                                                                       "Initial":"Initialized"}})
                }
                if(currentprocess.currentIndex == -1)
                {
                    processselection.visible = true
                    segmentselection.visible = segmentnum.currentIndex == -1 ? true : false
                    wrongsegbase.visible = !isInt(Number(segmentbase.text))
                    wrongsegsize.visible = !isInt(Number(segmentsize.text))
                }
                if(segmentnum.currentIndex == -1)
                {
                    segmentselection.visible = true
                    processselection.visible = currentprocess.currentIndex == -1 ? true : false
                    wrongsegbase.visible = !isInt(Number(segmentbase.text))
                    wrongsegsize.visible = !isInt(Number(segmentsize.text))
                }
                if(!isInt(Number(segmentbase.text)))
                {
                    wrongsegbase.visible = true
                    processselection.visible = currentprocess.currentIndex == -1 ? true : false
                    segmentselection.visible = segmentnum.currentIndex == -1 ? true : false
                    wrongsegsize.visible = !isInt(Number(segmentsize.text))
                }
                if(!isInt(Number(segmentsize.text)))
                {
                    wrongsegsize.visible = true
                    processselection.visible = currentprocess.currentIndex == -1 ? true : false
                    segmentselection.visible = segmentnum.currentIndex == -1 ? true : false
                    wrongsegbase.visible = !isInt(Number(segmentbase.text))
                }
            }
        }
        CustomizingButton {
            id: submitprocess
            text: "Allocate Process"
            Layout.column: 1
            Layout.row: 5
            onClicked: {

            }
        }
    }
    TableView {
        id: segments_table
        width: item.width/2.5
        height: item.height*0.35
        anchors.bottom: item.bottom
        anchors.right: item.right
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        focus: true
        model: segmentdata
        visible: currentprocess.currentIndex != -1 && segmentsconfigration.visible ? true : false
        rowDelegate: Rectangle {
            height: textrow.implicitHeight * 1.2
            width: textrow.implicitWidth
            color: {
                if(styleData.row < segmentNum && segmentdata.get(styleData.row).Initial === "Initialized")
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
            role: "SegmentName"
            title: "Segments"
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
}
