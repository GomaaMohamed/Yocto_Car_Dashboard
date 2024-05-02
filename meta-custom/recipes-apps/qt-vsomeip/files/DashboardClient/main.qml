import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import "./Component"

Window {
    id: root
    visible: true
    width: Screen.width
    height: Screen.height
    title: qsTr("DashBoard")
    flags: Qt.Window | Qt.FramelessWindowHint
    FontLoader {
            id: customFont
            source: "qrc:Fonts/fontawesome.otf"}
    GridLayout {
        anchors.fill: parent

        Dashboard {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: parent.height
            Layout.maximumHeight: 900
            Layout.maximumWidth: 1600
            Layout.minimumHeight: 25
            Layout.minimumWidth: 50
        }
    }
    
    
}
