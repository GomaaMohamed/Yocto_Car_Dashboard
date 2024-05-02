import QtQuick 2.0

Item {
    id: id_root
    property int value: 0

    Rectangle {
        id: id_tacho

        property int numberIndexs: 7
        property int startAngle: 234
        property int angleLength: 42
        property int maxSpeed: 6000

        anchors.centerIn: parent
        height: Math.min(id_root.width, id_root.height)
        width: height
        radius: width / 2
        color: "black" // Dark gray background color
        border.color: "#CCCCCC" // Light gray border color
        border.width: id_tacho.height * 0.02

        // Draw speedometer ticks using Canvas
        Canvas {
            id: canvas
            anchors.fill: parent
            contextType: "2d"
            rotation: 145
            antialiasing: true

            onPaint: {
                var context = canvas.getContext('2d');
                
                // Draw green arc segment for lower speed range
                context.strokeStyle = "#00ff00"; // Green color
                context.lineWidth = id_tacho.height * 0.06 / 2;
                context.beginPath();
                context.arc(id_tacho.height / 2, id_tacho.height / 2, id_tacho.height / 2 - id_tacho.height * 0.015, 0, Math.PI * 0.95, false);
                context.stroke();

                // Draw red arc segment for higher speed range
                context.strokeStyle = "#ff1a1a"; // Red color
                context.lineWidth = id_tacho.height * 0.06 / 2;
                context.beginPath();
                context.arc(id_tacho.height / 2, id_tacho.height / 2, id_tacho.height / 2 - id_tacho.height * 0.015, Math.PI * 0.95, Math.PI * 1.4, false);
                context.stroke();
            }
        }

        // Draw speedometer indicators
        Repeater {
            model: id_tacho.numberIndexs

            Item {
                height: id_tacho.height / 2
                transformOrigin: Item.Bottom
                rotation: index * id_tacho.angleLength + id_tacho.startAngle
                x: id_tacho.width / 2

                Rectangle {
                    height: id_tacho.height * 0.06
                    width: height / 4
                    color: "#FFFFFF" // White color
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: id_tacho.height * 0.01
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    x: 0
                    y: id_tacho.height * 0.09
                    color: "#FFFFFF" // White color
                    rotation: 360 - (index * id_tacho.angleLength + id_tacho.startAngle)
                    text: index 
                    font.pixelSize:  id_tacho.height * 0.05 // Increased font size
                    font.family: "Arial"
                }
            }
        }
    }



    // Draw speedometer indicators
        Repeater {
            model: 13

            Item {
                height: id_tacho.height / 2
                transformOrigin: Item.Bottom
                rotation: index * 21 + id_tacho.startAngle
                x: id_tacho.width / 2

                Rectangle {
                    height: id_tacho.height * 0.03
                    width: height / 2
                    color: "#FFFFFF" // White color
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: id_tacho.height * 0.01
                }
            }
        }
    
    // Draw speedometer indicators
        Repeater {
            model: 60

            Item {
                height: id_tacho.height / 2
                transformOrigin: Item.Bottom
                rotation: index * 4.2 + id_tacho.startAngle
                x: id_tacho.width / 2

                Rectangle {
                    height: id_tacho.height * 0.015
                    width: height / 2
                    color: "#FFFFFF" // White color
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: id_tacho.height * 0.01
                }
            }
        }

    // Center circle
    Rectangle {
        id: id_center
        anchors.centerIn: parent
        height: id_tacho.height * 0.05
        width: height
        radius: width / 2
        gradient: Gradient {
            GradientStop { position: 0.0; color: "red" } // Light red color
            GradientStop { position: 1.0; color: "red" } // Red color
        }
    }

    // Speed label
    Text {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: id_tacho.verticalCenter
            topMargin: id_tacho.height * 0.1
        }
        text: "X1000\n RPM"
        color: "#FFFFFF" // White color
        font.pixelSize: id_tacho.height * 0.06 // Increased font size
        font.family: "Arial"
    }

    // Speed needle
    Needle {
        id: id_tachoNeedle
        anchors {
            top: id_tacho.top
            bottom: id_tacho.bottom
            horizontalCenter: parent.horizontalCenter
        }
        value: 22*SpeedCppSide
        startAngle: id_tacho.startAngle
        angleLength: id_tacho.angleLength / (id_tacho.maxSpeed / (id_tacho.numberIndexs - 1))
    }
}
