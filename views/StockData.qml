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
        //dataModel.appendRow({"code":"小明", "qfq":"男", "id":"w0000065628743342144321241", "option":true})
    }

    function handleData(datastr){  
        console.log(datastr)
        var records=JSON.parse(datastr)
        console.log(records)
        dataModel.clear()
        records.forEach(function(item){
            //dataModel.appendRow({"code":"小明", "qfq":"男", "id":"w0000065628743342144321241", "option":true})
            dataModel.appendRow(item)
        })

    }


    TableModel{
        id:dataModel
        //TableModelColumn { display: "close" }
        TableModelColumn { display: "pre_close" }
    }

    HorizontalHeaderView {
        id: header
        width: parent.width
        syncView: tableView
        anchors.left: tableView.left
        model:[ 'QFQ']
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