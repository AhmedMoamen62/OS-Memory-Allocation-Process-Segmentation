import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    id: control

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color:  "black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 40
        color: "orange"
        opacity: enabled ? 1 : 0.3
        border.color: control.down ? "orange" : "black"
        border.width: 1
        radius: 2
    }
}
