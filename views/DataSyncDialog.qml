import QtQuick 2.15
import QtCharts 2.3
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQml.Models
import QtQuick.Controls.Material
import RS.Controllers.StockController 1.0

Item{
    id:customeDlg
    signal open()
    Component.onCompleted: {
        customeDlg.open.connect(dialog.open)
    }

    StockController{
        id:"stockCtl"
    }

    Dialog {
        id: dialog

        width:800
        height:400

        ColumnLayout {

            anchors.fill: parent

            Row{
                height:100
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
                        text:"2023-03-01"
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
                        text:"2023-04-01"
                        placeholderText: qsTr("2023-04-01")
                    }
                }

            }
            Row{
                height:100
                spacing: 10
                Control{
                    width: 120
                    height: parent.height
                    Label {

                        anchors.centerIn: parent
                        text: "代码(逗号分割)"
                    }
                }
                Control{
                    width: 600
                    height: parent.height
                    TextField {
                        id:stockCodes
                        width:parent.width
                        anchors.centerIn: parent
                        text:"000001.SZ, 000002.SZ"
                        placeholderText: qsTr("000001.SZ, 000002.SZ")
                    }
                }
            }
            Row{
                height:20
                width: parent.width
                Control{
                    anchors.fill:parent
                    ProgressBar {
                        id:percent
                        anchors.fill:parent
                        value: 0
                    }
                }
            }
            Row{
                height:80
                width: parent.width
                spacing: 10
                Control{
                    anchors.right: parent.right
                    width: 100
                    height: parent.height
                    Button{
                        text:"数据同步"
                        onClicked: {
                            percent.value=0.0
                            var stocks=stockCodes.text.split(",")
                            stocks.forEach(function(item,index){
                                stockCtl.syncData(item,startDate.text.replace(/-/g,""),stopDate.text.replace(/-/g,""))
                                percent.value=(index+1)/stocks.length
                            });

                        }
                    }
                }
            }


        }
    }

}
