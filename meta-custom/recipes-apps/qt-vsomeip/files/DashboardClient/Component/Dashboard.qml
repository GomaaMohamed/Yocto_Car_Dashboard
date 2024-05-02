import QtQuick 2.0

Item {
    id: id_dashboard

    //to creating data for demonstration purpose
    property int count: 0
    property int randNum: 0
    property string dashboardLightStatus: "red"
    property string dashboardLaneStatus: "gray"
    property string dashboardDoorsStatus: "yellow"
    property string dashboardSeatbeltStatus: "red"
    property string dashboardBatteryStatus: "gray"
    property string dashboardOilStatus: "yellow"
    property string dashboardEngineStatus: "gray"
    property string dashboardAbsStatus: "gray"
    property bool rightSign: true
    property bool leftSign: true
    property int fuelPercentage: FuelCppSide
    property int temperature: TemperatureCppSide
    
    Timer {
        id: id_timer
        repeat: true
        interval: 500
        running: true

        onTriggered: {
            count++;
            if(count % 2 == 0 && rightSign == true){
                id_turnRight.isActive = true
            }else
            {
                id_turnRight.isActive = false
            }
            if(count % 2 == 0 && leftSign == true){
                id_turnLeft.isActive = true
            }
            else{
                id_turnLeft.isActive = false
            }
        }
    }

    Image{
        //visible: false
        id: id_panel
        z:-2
        sourceSize: Qt.size(root.width,root.height)
        anchors.centerIn: parent
        source: "qrc:Icons/Panel.png"
        visible: true

    Rectangle {
    id: id_speedArea

    // Anchors
    anchors {
        bottom: parent.bottom
        right: parent.right
        rightMargin:parent.width * 0.05
        //bottomMargin: parent.
    }

    // Size
    width: parent.width * 0.38
    height: width

    // Styling
    gradient: Gradient {
        GradientStop { position: 0.0; color: "blue" } // Start color
        GradientStop { position: 0.5; color: "white" } // End color
    }
    border.color: "black"
    border.width: 2
    radius: width / 2
    z: 1

    // Child component
    Speed {
        id: id_speed
        anchors.fill: parent
        anchors.margins: id_speedArea.width * 0.025
    }
}

    Rectangle {
    id: id_tachoArea

    // Anchors
    anchors {
        bottom: parent.bottom
        left: parent.left
        leftMargin:parent.width * 0.05
    }

    // Size
    width: parent.width * 0.38
    height: width

    // Styling
    gradient: Gradient {
        GradientStop { position: 0.0; color: "blue" } // Start color
        GradientStop { position: 0.5; color: "white" } // End color
    }
    border.color: "black"
    border.width: 2
    radius: width / 2
    z: 1

    // Child component
    Tacho {
        id: id_tacho
        anchors.fill: parent
        anchors.margins: id_tachoArea.width * 0.025
    }
}

 /*****************  Lanes *****************/
    Image{
        id: id_lane
        sourceSize: Qt.size(id_panel.width*0.14,id_panel.height*0.3)
        anchors {
        centerIn: parent
        //margins: id_panel.width * 0.12
    }
        source: {
            switch (dashboardLaneStatus) {
                case "red":
                    return "qrc:Icons/LaneDeparture_red.svg";
                case "gray":
                    return "qrc:Icons/LaneDeparture.svg";
                case "green":
                   return "qrc:Icons/LaneDeparture_green.svg";
                case "white":
                    return "qrc:Icons/LaneDeparture_white.svg";
                default:
                    return ""; // Default image source
            }
        }
        
        visible: true}
    /***************** Doors ***************/

    Rectangle
    {

        anchors{
            bottom: id_lane.top
            bottomMargin: id_lane.height * 0.12
            horizontalCenter: id_lane.horizontalCenter
        }
        width: id_lane.width * 1.2 
        height: id_lane.height * 0.4
        radius: height / 3 
        color: "black"
        Text
        {
            anchors.centerIn:parent
            //anchors.bottom:parent.bottom
            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.bottomMargin: parent.height * 0.25
            text: "1256 km"
            font.pixelSize: parent.height * 0.5
            font.bold: true
            color: "#ffffff"

        }
    }
    // Gear
    Rectangle{

        anchors{
            top: id_lane.bottom
            topMargin: id_lane.height * 0.04
            horizontalCenter: id_lane.horizontalCenter
        }
        width: id_lane.width * 0.3
        height: width
        radius: height / 2 
        color: "black"
        Text
        {
            anchors.centerIn:parent
            text: "N"
            font.pixelSize: parent.height * 0.7
            font.bold: true
            color: "#00ff00"

        }
    }

    /*************************** Fuel ******************************/
     Image{

        id: id_fuelArea
        anchors{
            right:id_lane.right
            rightMargin: -height * 0.5
            bottom:id_panel.bottom
            bottomMargin: id_lane.width*0.1
        }
        width: id_lane.width*0.4
        height: width  
        source: "qrc:Icons/fuel-icon.png"
        visible: true 
    }    
     Rectangle {
    id: id_temperatureBar
    anchors {
        right: id_fuelArea.left
        rightMargin: id_fuelArea.width * 0.1 // Adjust as needed
        bottom: id_fuelArea.bottom
    }
    width: id_fuelArea.width * 0.4
    height: id_fuelArea.height * 1.05 
    border.color: "white" // Border color
    border.width: id_fuelArea.width * 0.1 // Border width

    Rectangle {
        width: id_fuelArea.width * 0.35
        height: id_fuelArea.height *  fuelPercentage / 100
        color:  {if(fuelPercentage>66) {return "#00ff00"; }
                else if(fuelPercentage <= 66 && fuelPercentage >= 25) {return "yellow"; }
                else if(fuelPercentage < 25) {return "red"; } 
                }
        anchors
        {
            bottom:parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

    }
}
    Text {
        anchors {
            top: id_temperatureBar.top
            right: id_temperatureBar.left
            rightMargin: id_fuelArea.width * 0.05
            topMargin: - id_fuelArea.width * 0.2
        }
        text: "F"
        color: "#00ff00" // White color
        font.pixelSize: id_temperatureBar.height * 0.3 // Increased font size
        font.family: "Arial"
    }
    Text {
        anchors {
            bottom: id_temperatureBar.bottom
            right: id_temperatureBar.left
            rightMargin: id_fuelArea.width * 0.05
            bottomMargin: - id_fuelArea.width * 0.2
        }
        text: "E"
        color: "red" // White color
        font.pixelSize: id_temperatureBar.height * 0.3 // Increased font size
        font.family: "Arial"
    }
    /****************** Temperature *******************/ 
    Image{

        id: id_temperatureArea
        anchors{
            left:id_lane.left 
            leftMargin: -height*0.5
            bottom:id_panel.bottom
            bottomMargin: id_lane.width*0.1
        }
        width: id_lane.width*0.3
        height: width * 1.5 
        source: "qrc:Icons/temperature-icon.png"
        visible: true 
        
    }
    Rectangle {
    id: id_fuelBar
    anchors {
        left: id_temperatureArea.right
        leftMargin: id_fuelArea.width * 0.1 // Adjust as needed
        bottom: id_fuelArea.bottom
    }
    width: id_fuelArea.width * 0.4
    height: id_fuelArea.height * 1.05 
    border.color: "white" // Border color
    border.width: id_fuelArea.width * 0.1 // Border width

    Rectangle {
        width: id_fuelArea.width * 0.35
        height: id_fuelArea.height *  temperature / 100
        color:  {if(temperature > 66) {return "red"; }
                else if(temperature <= 66 && temperature >= 33 ) {return "yellow"; }
                else  {return "#00ff00"; } 
                }
        anchors
        {
            bottom:parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

    }
}
    Text {
        anchors {
            top: id_fuelBar.top
            left: id_fuelBar.right
            leftMargin: id_fuelArea.width * 0.05
            topMargin: - id_fuelArea.width * 0.2
        }
        text: "C"
        color: "red" // White color
        font.pixelSize: id_temperatureBar.height * 0.3 // Increased font size
        font.family: "Arial"
    }
     
    

     Image{
        sourceSize: Qt.size(id_turnLeft.width*0.8 ,id_turnLeft.height*0.8)
        anchors {
        left: id_turnLeft.right
        right: id_turnRight.left
        top: id_panel.top
        topMargin: id_panel.height * 0.027
        rightMargin: id_turnLeft.width * 0.8
        leftMargin: id_turnLeft.width * 0.8}
        
        source:{
            switch (dashboardLightStatus) {
                case "red":
                    return "qrc:Icons/Lights_red.svg";
                case "gray":
                    return "qrc:Icons/Lights.svg";
                case "yellow":
                    return "qrc:Icons/Lights_yellow.svg";
                default:
                    return ""; // Default image source
            }
        }
        
        visible: true}

        

    Sign {
        id: id_turnLeft

        anchors {
            left: id_panel.left
            leftMargin: id_panel.height * 0.9
            top: id_panel.top
            topMargin: id_panel.height * 0.02
        }
        width: id_panel.width / 22
        height: id_panel.height / 12

        isActive: false
    }

    Sign {
        id: id_turnRight

        anchors {
            right: id_panel.right
            rightMargin: id_panel.height * 0.9
            top: id_panel.top
            topMargin: id_panel.height * 0.02
        }
        width: id_panel.width / 22
        height: id_panel.height / 12
        transformOrigin: Item.Center
        rotation: 180

        isActive: false
    }

    Image{
        id:id_battery
        sourceSize: Qt.size(id_turnLeft.width*0.8 ,id_turnLeft.height*0.8)
        anchors {
        left: id_turnRight.right
        top: id_panel.top
        topMargin: id_panel.height * 0.027
        leftMargin: id_turnLeft.height * 0.6
        }
        
        source:{
            switch (dashboardBatteryStatus) {
                case "red":
                    return "qrc:Icons/Battery_red.svg";
                case "gray":
                    return "qrc:Icons/Battery.svg";
                case "yellow":
                    return "qrc:Icons/Battery_yellow.svg";
                default:
                    return ""; // Default image source
            }
        }
        visible: true}

    
    Image{
        id: id_oil
        sourceSize: Qt.size(id_turnLeft.width*0.8 ,id_turnLeft.height*0.8)
        anchors {
        left: id_battery.right
        top: id_panel.top
        topMargin: id_panel.height * 0.03
        leftMargin: id_turnLeft.height * 0.6
        }
        
        source:{
            switch (dashboardOilStatus) {
                case "red":
                    return "qrc:Icons/Oil_red.svg";
                case "gray":
                    return "qrc:Icons/Oil.svg";
                case "yellow":
                    return "qrc:Icons/Oil_yellow.svg";
                default:
                    return ""; // Default image source
            }
        }
        visible: true}

    Image{
        id: id_engine
        sourceSize: Qt.size(id_turnLeft.width*0.8 ,id_turnLeft.height*0.8)
        anchors {
        left: id_oil.right
        top: id_panel.top
        topMargin: id_panel.height * 0.042
        leftMargin: id_turnLeft.height * 0.6
        }
        
        source:{
            switch (dashboardEngineStatus) {
                case "red":
                    return "qrc:Icons/Engine_red.svg";
                case "gray":
                    return "qrc:Icons/Engine.svg";
                case "yellow":
                    return "qrc:Icons/Engine_yellow.svg";
                default:
                    return ""; // Default image source
            }
        }
        visible: true}

    Image{
        id:id_door
        sourceSize: Qt.size(id_turnLeft.width*0.8 ,id_turnLeft.height*0.8)
        anchors {
        right: id_turnLeft.left
        top: id_panel.top
        topMargin: id_panel.height * 0.027
        rightMargin: id_turnLeft.height * 0.6
        }
        
        source:{
            switch (dashboardDoorsStatus) {
                case "red":
                    return "qrc:Icons/OpenDoor_red.svg";
                case "gray":
                    return "qrc:Icons/OpenDoor.svg";
                case "yellow":
                    return "qrc:Icons/OpenDoor_yellow.svg";
                default:
                    return ""; // Default image source
            }
        }
        visible: true}

    Image{
        id: id_seatBelt
        sourceSize: Qt.size(id_turnLeft.width*0.8 ,id_turnLeft.height*0.8)
        anchors {
        right: id_door.left
        top: id_panel.top
        topMargin: id_panel.height * 0.03
        rightMargin: id_turnLeft.height * 0.6
        }
        
        source:{
            switch (dashboardSeatbeltStatus) {
                case "red":
                    return "qrc:Icons/Seatbelt_red.svg";
                case "gray":
                    return "qrc:Icons/Seatbelt.svg";
                case "yellow":
                    return "qrc:Icons/Seatbelt_yellow.svg";
                default:
                    return ""; // Default image source
            }
        }
        visible: true}

    Image{
        id: id_abs
        sourceSize: Qt.size(id_turnLeft.width*0.8 ,id_turnLeft.height*0.8)
        anchors {
        right: id_seatBelt.left
        top: id_panel.top
        topMargin: id_panel.height * 0.042
        rightMargin: id_turnLeft.height * 0.6
        }
        
        source:{
            switch (dashboardAbsStatus) {
                case "red":
                    return "qrc:Icons/ABS_red.svg";
                case "gray":
                    return "qrc:Icons/ABS.svg";
                case "yellow":
                    return "qrc:Icons/ABS_yellow.svg";
                default:
                    return ""; // Default image source
            }
        }
        visible: true}

    }


}