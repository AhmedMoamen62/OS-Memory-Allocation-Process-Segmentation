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
    property string fitting
    property string currentProcess: ""
    property bool firstTime: true
    property var memorySegments: []
    property alias segConfigVisibility: segmentsconfigration.visible
    property alias currentProcessIndex: currentprocess.currentIndex
    property ListModel processSegmentsData: ListModel {
    }
    signal generateProcessConfigration()
    signal allocateProcess()
    signal deallocateProcess(int index)
    signal callAllocation(string process)
    signal callDeallocation(string process)
    onAllocateProcess: {
        refreshTableSegments()
        showState(processSegmentsData.get(currentprocess.currentIndex).State)
        showEditProcess(processSegmentsData.get(currentprocess.currentIndex).State)
        if(processSegmentsData.get(currentprocess.currentIndex).State === "Pending")
        {
            pendingprocess.open()
        }
    }
    onDeallocateProcess: {
        deallocateprocess(index)
    }
    onGenerateProcessConfigration: {
        showDefaultConfigration()
    }
    function isInt(n){
        return Number(n) === n && n % 1 === 0 && Number(n) !== 0;
    }
    function setProcessName()
    {
        var name = "P1"
        for(var i = 0 ; i < processSegmentsData.count ; i++)
        {
            for(var j = 0 ; j < processSegmentsData.count ; j++)
            {
                if(processSegmentsData.get(j).Name === name)
                {
                    break
                }
                if(j === processSegmentsData.count - 1)
                {
                    return name
                }
            }
            name = "P" + (i + 2)
        }
        return name
    }
    function deallocateprocess(index)
    {
        if(index !== -1)
        {
            processSegmentsData.remove(index)
            processlist.remove(index)
            processNum--
            if(processNum > 0)
            {
                currentprocess.currentIndex = 0
                currentProcess = currentprocess.currentText
                fitting = processSegmentsData.get(currentprocess.currentIndex).Fitting
                refreshTableSegments()
                if(processSegmentsData.get(currentprocess.currentIndex).State === "None")
                {
                    hideState()
                    hideEditProcess()
                }
                else
                {
                    showState(processSegmentsData.get(currentprocess.currentIndex).State)
                    showEditProcess(processSegmentsData.get(currentprocess.currentIndex).State)
                }
            }
            else
            {
                showDefaultConfigration()
            }
        }
        else
        {
            refreshTableSegments()
        }
    }
    function setSegmentsState(state,index)
    {
        for(var i = 0 ; i < processSegmentsData.get(index).Process.count ; i++)
        {
            processSegmentsData.get(index).Process.set(i,{"Segment":{"SegmentName":processSegmentsData.get(index).Process.get(i).Segment.SegmentName,
                                                                               "base":processSegmentsData.get(index).Process.get(i).Segment.base,
                                                                               "size":processSegmentsData.get(index).Process.get(i).Segment.size,
                                                                               "Initial":processSegmentsData.get(index).Process.get(i).Segment.Initial,
                                                                               "state":state}})
        }
    }
    function showEditProcess(state)
    {
        if(state === "Allocated")
        {
            deleteprocess.visible = true
            submitsegment.visible = false
            allocateprocess.visible = false
        }
        else if(state === "Pending")
        {
            deleteprocess.visible = false
            submitsegment.visible = false
            allocateprocess.visible = false
        }
    }
    function hideEditProcess()
    {
        deleteprocess.visible = false
        submitsegment.visible = true
        allocateprocess.visible = true
    }
    function showState(state)
    {
        if(state === "Allocated")
        {
            initialcolumn.visible = false
            basecolumn.visible = true
            statecolumn.visible = true
        }
        else if(state === "Pending")
        {
            initialcolumn.visible = false
            basecolumn.visible = false
            statecolumn.visible = true
        }
    }
    function hideState()
    {
        initialcolumn.visible = true
        basecolumn.visible = false
        statecolumn.visible = false
    }
    function checkSegmentsInitialization()
    {
        for(var j = 0 ; j < processSegmentsData.count ; j++)
        {
            for(var i = 0 ; i < processSegmentsData.get(j).Process.count; i++)
            {
                if(processSegmentsData.get(j).Process.get(i).Segment.Initial === "Not Initialized")
                {
                    return false
                }
            }
        }
        return true
    }
    function processConfigrationDisplaying()
    {
        segmentsconfigration.visible = false
        segmentnumber.visible = true
        segmenttext.visible = true
        sumbitsegmentNumber.visible = true
        firstfit.visible = true
        bestfit.visible = true
    }
    function processConfigrationHiding()
    {
        segmentsconfigration.visible = true
        segmentnumber.visible = false
        segmenttext.visible = false
        sumbitsegmentNumber.visible = false
        firstfit.visible = false
        bestfit.visible = false
    }
    function showDefaultConfigration()
    {
        firstTime = true
        processSegmentsData.clear()
        processlist.clear()
        segmentsname.clear()
        segmentdata.clear()
        memorySegments = []
        processNum = 0
        segmentNum = 0
        segmentsconfigration.visible = false
        segmentnumber.visible = false
        segmenttext.visible = false
        sumbitsegmentNumber.visible = false
        firstfit.visible = false
        bestfit.visible = false
    }
    function refreshTableSegments()
    {
        segmentdata.clear()
        segmentsname.clear()
        memorySegments = []
        for(var i = 0 ; i < processSegmentsData.get(currentprocess.currentIndex).Process.count ; i++)
        {
            var segments = {Type: "",id: "",segmentName: "",state: "",algorithmType: "",base: 0,size: 0}
            segments.Type = "segment"
            segments.id = processSegmentsData.get(currentprocess.currentIndex).Name
            segments.segmentName = processSegmentsData.get(currentprocess.currentIndex).Process.get(i).Segment.SegmentName
            segments.base = processSegmentsData.get(currentprocess.currentIndex).Process.get(i).Segment.base
            segments.size = processSegmentsData.get(currentprocess.currentIndex).Process.get(i).Segment.size
            segments.algorithmType = processSegmentsData.get(currentprocess.currentIndex).Fitting
            memorySegments[i] = segments
            segmentsname.append({"name":processSegmentsData.get(currentprocess.currentIndex).Process.get(i).Segment.SegmentName})
            segmentdata.append({"SegmentName":processSegmentsData.get(currentprocess.currentIndex).Process.get(i).Segment.SegmentName,
                                   "base":processSegmentsData.get(currentprocess.currentIndex).Process.get(i).Segment.base,
                                   "size":processSegmentsData.get(currentprocess.currentIndex).Process.get(i).Segment.size,
                                   "Initial":processSegmentsData.get(currentprocess.currentIndex).Process.get(i).Segment.Initial,
                                   "state":processSegmentsData.get(currentprocess.currentIndex).Process.get(i).Segment.state})
        }
    }
    function addProcess()
    {
        var segmentsDataList = {"SegmentName": "None", "base":0, "size": 0, "Initial": "Not Initialized", "state":"None"}
        segmentsname.clear()
        segmentdata.clear()
        memorySegments = []
        segmentNum = segmentnumber.value
        for(var j = 0 ;j < segmentNum ; j++)
        {
            segmentdata.append({"SegmentName":"Seg "+(j+1),
                                   "base":0,
                                   "size":0,
                                   "Initial":"Not Initialized",
                                   "state":"None"})
        }
        processNum++
        fitting = firstfit.checked ? "firstfit" : "bestfit"
        processlist.append({"name":setProcessName()})
        processSegmentsData.append({"Process":[],"Fitting":fitting,"State": "None","Name":setProcessName(),"CalledAllocation": false})
        for(var i = 0 ; i < segmentNum ; i++)
        {
            segmentsname.append({"name":"Seg "+(i+1)})
            segmentsDataList.SegmentName = segmentdata.get(i).SegmentName
            segmentsDataList.base = 0
            segmentsDataList.size = segmentdata.get(i).size
            segmentsDataList.Initial = segmentdata.get(i).Initial
            segmentsDataList.state = segmentdata.get(i).state
            processSegmentsData.get(processNum - 1).Process.append({"Segment":{"SegmentName":segmentsDataList.SegmentName,
                                                                               "base":0,
                                                                               "size":segmentsDataList.size,
                                                                               "Initial":segmentsDataList.Initial,
                                                                               "state":segmentsDataList.state}})
        }
        currentprocess.currentIndex = processNum - 1
        currentProcess = currentprocess.currentText
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
    MessageDialog {
        id: pendingprocess
        title: "Pending Process"
        text: "There's no enough space to allocate this process, deallocate enough space first and it will allocate in memory automatically"
        icon: StandardIcon.Information
        standardButtons: StandardButton.Ok
    }
    GridLayout {
        id: basicsconfigration
        columns: 2
        rows: 4
        columnSpacing: 5
        rowSpacing: 10
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 20
        anchors.leftMargin: 90
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
                if(firstTime)
                {
                    firstTime = false
                    processConfigrationDisplaying()
                }
                else
                {
                    if(checkSegmentsInitialization())
                    {
                        processConfigrationDisplaying()
                    }
                    else
                    {
                        segmentsnotfinished.open()
                    }
                }
            }
        }
        CustomizingButton {
            id: sumbitsegmentNumber
            text: "Submit"
            Layout.column: 0
            Layout.row: 3
            visible: false
            onClicked: {
                addProcess()
                processConfigrationHiding()
            }
        }
    }
    MessageDialog {
        id: segmentsnotfinished
        title: "Segments Initialization"
        text: "Not All Segments are initialized or there is a wrong base or size, Please check and initialize them"
        icon: StandardIcon.Information
        standardButtons: StandardButton.Ok
    }
    GridLayout {
        id: segmentsconfigration
        columns: 3
        rows: 7
        columnSpacing: 5
        rowSpacing: 10
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
            text: "Segment Size:"
            font.bold: true
            font.family: "Comic Sans MS"
            Layout.row: 3
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
            id: wrongsegsize
            text: "Please enter a +ve int seg. size"
            font.family: "Comic Sans MS"
            Layout.row: 3
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
                if(processSegmentsData.get(currentprocess.currentIndex).State === "None")
                {
                    hideEditProcess()
                    hideState()
                }
                else
                {
                    showEditProcess(processSegmentsData.get(currentprocess.currentIndex).State)
                    showState(processSegmentsData.get(currentprocess.currentIndex).State)
                }
                refreshTableSegments()
                fitting = processSegmentsData.get(currentprocess.currentIndex).Fitting
                currentProcess = processSegmentsData.get(currentprocess.currentIndex).Name
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
            id: segmentsize
            placeholderText: "Enter Seg Size"
            Layout.column: 1
            Layout.row: 3
        }
        CustomizingButton {
            id: submitsegment
            text: "Submit Segment"
            Layout.column: 0
            Layout.row: 4
            onClicked: {
                if(segmentnum.currentIndex != -1 && currentprocess.currentIndex != - 1 && isInt(Number(segmentsize.text)))
                {
                    var segments = {Type: "",id: "",segmentName: "",state: "",algorithmType: "",base: 0,size: 0}
                    processselection.visible = false
                    segmentselection.visible = false
                    wrongsegsize.visible = false
                    segments.Type = "segment"
                    segments.id = currentprocess.currentText
                    segments.segmentName = Number(segmentname.text) !== 0 ? segmentname.text : segmentsname.get(segmentnum.currentIndex).name
                    segments.base = 0
                    segments.size = Number(segmentsize.text)
                    segments.algorithmType = processSegmentsData.get(currentprocess.currentIndex).Fitting
                    segmentdata.set(segmentnum.currentIndex,{"SegmentName":segments.segmentName,
                                        "base":0,
                                        "size":segments.size,
                                        "Initial":"Initialized",
                                        "state":"None"})
                    processSegmentsData.get(currentprocess.currentIndex).Process.set(segmentnum.currentIndex,{"Segment":{"SegmentName":segments.segmentName,
                                                                                       "base":0,
                                                                                       "size":segments.size,
                                                                                       "Initial":"Initialized",
                                                                                       "state":"None"}})
                    memorySegments[segmentnum.currentIndex] = segments
                }
                if(currentprocess.currentIndex == -1)
                {
                    processselection.visible = true
                    segmentselection.visible = segmentnum.currentIndex == -1 ? true : false
                    wrongsegsize.visible = !isInt(Number(segmentsize.text))
                }
                if(segmentnum.currentIndex == -1)
                {
                    segmentselection.visible = true
                    processselection.visible = currentprocess.currentIndex == -1 ? true : false
                    wrongsegsize.visible = !isInt(Number(segmentsize.text))
                }
                if(!isInt(Number(segmentsize.text)))
                {
                    wrongsegsize.visible = true
                    processselection.visible = currentprocess.currentIndex == -1 ? true : false
                    segmentselection.visible = segmentnum.currentIndex == -1 ? true : false
                }
            }
        }
        CustomizingButton {
            id: allocateprocess
            text: "Allocate Process"
            Layout.column: 1
            Layout.row: 4
            onClicked: {
                if(checkSegmentsInitialization())
                {
                    processSegmentsData.get(currentprocess.currentIndex).CalledAllocation = true
                    callAllocation(currentprocess.currentText)
                }
                else
                {
                    segmentsnotfinished.open()
                }
            }
        }
        CustomizingButton {
            id: deleteprocess
            text: "Deallcote"
            Layout.column: 0
            Layout.row: 5
            visible: false
            onClicked: {
                callDeallocation(currentprocess.currentText)
            }
        }
    }
    TableView {
        id: segments_table
        width: item.width*0.4
        height: item.height*0.4
        anchors.top: segmentsconfigration.bottom
        anchors.left: segmentsconfigration.left
        anchors.topMargin: 30
        focus: true
        model: segmentdata
        visible: currentprocess.currentIndex != -1 && segmentsconfigration.visible ? true : false
        rowDelegate: Rectangle {
            height: textrow.implicitHeight * 1.2
            width: textrow.implicitWidth
            color: {
                if(styleData.row < segmentdata.count && segmentdata.get(styleData.row).Initial === "Initialized" && segmentdata.get(styleData.row).state === "None")
                {
                    return "gray"
                }
                else if(styleData.row < segmentdata.count && segmentdata.get(styleData.row).Initial === "Initialized" && segmentdata.get(styleData.row).state === "Allocated")
                {
                    return "green"
                }
                else if(styleData.row < segmentdata.count && segmentdata.get(styleData.row).Initial === "Initialized" && segmentdata.get(styleData.row).state === "Pending")
                {
                    return "red"
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
        TableViewColumn {
            id: basecolumn
            role: "base"
            title: "Base"
            visible: false
        }
        TableViewColumn {
            role: "size"
            title: "Size"
        }
        TableViewColumn {
            id: initialcolumn
            role: "Initial"
            title: "Initialization"
        }
        TableViewColumn {
            id: statecolumn
            role: "state"
            title: "State"
            visible: false
        }
    }
}
