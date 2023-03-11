import QtQuick 2.15
import QtCharts 2.2
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQml.Models
import QtQuick.Controls.Material
import Qt.labs.qmlmodels 1.0

import RS.Controllers.StockController 1.0


ColumnLayout {
    anchors.fill: parent

    GroupBox {
        Layout.fillWidth: true
        Layout.preferredHeight: parent.height*0.1
        Row{
            anchors.fill: parent
            spacing: 10
            Control{
                width: 50
                height: parent.height
                Label {
                    anchors.centerIn: parent
                    text: "开始"
                }
            }
            Control{
                width: 100
                height: parent.height
                TextField {
                    id:startDate
                    anchors.centerIn: parent
                    placeholderText: qsTr("2023-03-01")
                }
            }
            Control{
                width: 50
                height: parent.height
                Label {
                    anchors.centerIn: parent
                    text: "结束"
                }
            }
            Control{
                width: 100
                height: parent.height
                TextField {
                    id:stopDate
                    anchors.centerIn: parent
                    placeholderText: qsTr("2023-03-01")
                }
            }
            Control{
                width: 100
                height: parent.height
                Button {
                    text: "查看"
                    anchors.centerIn: parent
                    onClicked:{
                         //stockview.sdata=stockCtl.getData(2)
                         stockview.changeData(stockCtl.getData(20))
                    }
                }
            }

        }

    }

    GroupBox {
        Layout.fillWidth: true
        Layout.preferredHeight: parent.height*0.3
        StockData{
            id:stockview
            sdata:""
        }

    }
    GroupBox {
        Layout.fillWidth: true
        Layout.preferredHeight: parent.height*0.6
        //bottomPadding:100
        ChartView{
            anchors.fill: parent
            theme: ChartView.ChartThemeDark
            legend.alignment: Qt.AlignRight
            LineSeries {
                name: "LineSeries"
                XYPoint { x: 0; y: 0 }
                XYPoint { x: 1.1; y: 2.1 }
                XYPoint { x: 1.9; y: 3.3 }
                XYPoint { x: 2.1; y: 2.1 }
            }
        }
    }


}

