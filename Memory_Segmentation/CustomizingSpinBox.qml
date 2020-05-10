import QtQuick 2.12
import QtQuick.Controls 2.12


SpinBox {
    id: control
    value: 0
    editable: true
    from: 0
    contentItem: TextInput {
        z: 2
        text: control.textFromValue(control.value, control.locale)

        font: control.font
        color: "orange"
        selectionColor: "orange"
        selectedTextColor: "black"
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        readOnly: !control.editable
        validator: control.validator
        inputMethodHints: Qt.ImhFormattedNumbersOnly
    }

    up.indicator: Rectangle {
        x: control.mirrored ? 0 : parent.width - width
        height: parent.height
        implicitWidth: 40
        implicitHeight: 40
        radius: 3
        color: control.up.pressed ? "white" : "orange"
        border.color: "dark red"

        Text {
            text: "+"
            font.pixelSize: control.font.pixelSize * 2
            color: "dark red"
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    down.indicator: Rectangle {
        x: control.mirrored ? parent.width - width : 0
        height: parent.height
        implicitWidth: 40
        implicitHeight: 40
        radius: 3
        color: control.down.pressed ? "white" : "orange"
        border.color: "dark red"

        Text {
            text: "-"
            font.pixelSize: control.font.pixelSize * 2
            color: "dark red"
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    background: Rectangle {
        implicitWidth: 150
        radius: 3
        border.color: "orange"
        color: "black"
    }
}
