import QtQuick 2.0

Item {
    id: id_root
    property int value: 0
    property int startAngle: 0
    property double angleLength: 0
    property int maxSpeed: 0

    width: 100
    height: 300
    
    Rectangle {
        id: needle
        width: id_root.height * 0.01   // Width of the needle
        height: id_root.height * 0.45  // Height of the needle
        color: "red" // Color of the needle
        anchors.horizontalCenter: parent.horizontalCenter
        y: id_root.height * 0.05 // Position of the needle relative to the parent item

        transform: Rotation {
            origin.x: needle.width / 2 // Set rotation origin to center of the needle
            origin.y: needle.height // Set rotation origin to bottom of the needle
            angle: id_root.value * id_root.angleLength + id_root.startAngle // Rotate the needle based on the value property
        }
    }

    Behavior on rotation {
        SmoothedAnimation { velocity: 100 }
    }
}
