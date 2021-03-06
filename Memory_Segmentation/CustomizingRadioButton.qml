import QtQuick 2.12
import QtQuick.Controls 2.12

RadioButton {
    id: control
    indicator: Rectangle {
        implicitWidth: 20
        implicitHeight: 20
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 13
        border.color: control.down ? "yellow" : "orange"

        Rectangle {
            width: 10
            height: 10
            x: 6
            y: 6
            radius: 7
            color: control.down ? "yellow" : "orange"
            visible: control.checked
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? "yellow" : "orange"
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
