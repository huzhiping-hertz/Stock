import QtQuick 2.15
import QtCharts 2.2
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQml.Models
import QtQuick.Controls.Material
import Qt.labs.qmlmodels 1.0


ApplicationWindow {
    visible: true
    // width: 1600
    // height: 800
    visibility:"Maximized"
    Material.theme: Material.Dark
    Material.accent:Material.Blue
    menuBar: MenuBar {
        Menu {
            title: qsTr("文件")

            // Action {
            //     text: qsTr("保持布局")
            //     onTriggered: {
            //         layoutSaver.saveToFile("layout.json");
            //     }
            // }

            // Action {
            //     text: qsTr("恢复布局")
            //     onTriggered: {
            //         layoutSaver.restoreFromFile("layout.json");
            //     }
            // }

            // Action {
            //     text: qsTr("关闭窗格")
            //     onTriggered: {
            //         _kddwDockRegistry.clear();
            //     }
            // }

            MenuSeparator { }
            Action { text: qsTr("退出")
                onTriggered: {
                    Qt.quit();
                }
            }
        }
        // Menu{
        //     title: qsTr("视图")
        //     Action{
        //         text: qsTr("工具条")
        //         onTriggered: {
        //             toolBar.visible=true
        //         }
        //     }
        // }
        Menu{
            id: "plugs"
            title: qsTr("数据管理")
            Action {
                text: qsTr("同步数据")
                onTriggered: {
                    onClicked: dataSyncDlg.open()
                }
            }
        }

    }

    TabBar {
        id: bar
        width: parent.width
        TabButton {
            text: qsTr("数据")

        }
        TabButton {
            text: qsTr("模型")
        }
        TabButton {
            text: qsTr("批量计算")
        }
    }

    StackLayout {
        width:parent.width
        height:parent.height-bar.height
        anchors.top: bar.bottom
        currentIndex: bar.currentIndex
        GroupBox{
            width:parent.width
            height:parent.height
            StockPage{

            }

        }
        GroupBox{
            anchors.fill: parent
            ModelPage{

            }
        }
        GroupBox{
            //anchors.fill: parent
            ColumnLayout {
                anchors.fill: parent
                Rectangle {
                    color: 'green'
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height*0.1
                    Text {
                        anchors.centerIn: parent
                        text: parent.width + 'x' + parent.height
                    }
                }
                Rectangle {
                    color: 'green'
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height*0.3
                    Text {
                        anchors.centerIn: parent
                        text: parent.width + 'x' + parent.height
                    }
                }
                Rectangle {
                    color: 'green'
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height*0.7
                    Text {
                        anchors.centerIn: parent
                        text: parent.width + 'x' + parent.height
                    }
                }
            }
        }
    }

    DataSyncDialog{
        id:dataSyncDlg
    }


}
