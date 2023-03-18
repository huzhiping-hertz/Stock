import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQml.Models
import QtQuick.Controls.Material
import Qt.labs.qmlmodels 1.0

Item{
    id: stockTable
    property string sdata
    signal changeData(string sdata)
    anchors.fill: parent

    Component.onCompleted: {
        stockTable.changeData.connect(handleData)
    }

    function handleData(datastr){  
        var records=JSON.parse(datastr)
        dataModel.clear()
        records.forEach(function(item){
            dataModel.appendRow(item)
        })

    }


    TableModel{
        id:dataModel
        TableModelColumn { display: "code"}
        TableModelColumn { display: "pre_close"}
        TableModelColumn { display: "high"}
    }

    HorizontalHeaderView {
        id: header
        width: parent.width
        syncView: tableView
        anchors.left: tableView.left
        model:[ 'Code','Pre_Close','High']
        delegate:Rectangle{
            color: "#666666"
            implicitWidth: 100
            implicitHeight: 32
            border.width: 1
            border.color: "#848484"

            required property var modelData
            Text {
                text: "<b>"+modelData+"</b"
                anchors.centerIn: parent
                font.pointSize: 12
                color:"white"
            }
        }
    }
    TableView{
        id:tableView
        width: parent.width
        height:parent.height-header.height
        anchors.top:header.bottom
        clip: true
        boundsBehavior: Flickable.OvershootBounds


        ScrollBar.vertical: ScrollBar{
            anchors.right:parent.right
            anchors.rightMargin: 0
            visible: dataModel.rowCount() > 5
            background: Rectangle{
                color:"#666666"
            }
            onActiveChanged:{
                active = true;
            }
            contentItem: Rectangle{
                implicitWidth : 6
                implicitHeight : 30
                radius : 3
                color : "#848484"
            }
        }

        model: dataModel
        delegate:Rectangle{
            color: "#666666"
            implicitWidth: 100
            implicitHeight: 32
            border.width: 1
            border.color: "#848484"

            Text {
                text: display
                anchors.centerIn: parent
                font.pointSize: 12
                color: "white"
            }

        }

    }

}