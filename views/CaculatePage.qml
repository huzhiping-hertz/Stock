import QtQuick 2.15
import QtCharts 2.3
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQml.Models
import QtQuick.Controls.Material
import Qt.labs.qmlmodels 1.0

import RS.Controllers.StockController 1.0
import RS.Controllers.CaculatorController 1.0
import RS.Controllers.ModelController 1.0


ColumnLayout {
    anchors.fill: parent

    StockController{
        id:"stockCtl"
    }
    CaculatorController{
        id:"caculateCtl"
    }
    ModelController{
        id:"modelCtl"
    }
    Component.onCompleted: {
        var datastr=modelCtl.getNames();
        var records=JSON.parse(datastr)
        var names=new Array()
        records.forEach(function(item,index){
            names.push(item[0]);
        });
        modelNames.model=names;
        console.log(data);

        var stockstr=stockCtl.getStocks();
        records=JSON.parse(stockstr)
        print(stockstr)
        names=new Array()
        names.push("全部")
        records.forEach(function(item,index){
            names.push(item[0]);
        });
        print(names)
        stockCodes.model=names;
    }
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
                    text: "代码"
                }
            }
                
            ComboBox {
                width: 100
                height: parent.height
                id:stockCodes
            }

            
            Control{
                width: 50
                height: parent.height
                Label {
                    
                    anchors.centerIn: parent
                    text: "数据模型"
                }
            }
            ComboBox {
                    width: 120
                height: parent.height
                id:modelNames
            }
            

            
            Control{
                width: 100
                height: parent.height
                Button {
                    text: "相关性计算"
                    anchors.centerIn: parent
                    onClicked:{
                        // var start=String(startDate.text);
                        // var stop=String(stopDate.text);
                        // start=start.replace(/-/g,"");
                        // stop=stop.replace(/-/g,"");
                        var modelName=modelNames.currentValue;

                        var datastr=caculateCtl.getAllCorrilationData(modelName);
                        corrTable.changeData(datastr)

                    }
                }
            }

                            
            Control {
                width: 150
                height: parent.height
                    id:unite
                    // checked: false
                    // text: qsTr("归一化(min-max)")
            }
            
            Control {
                    width: 150
                    height: parent.height
                    id:corrshow
                    // checked: false
                    // text: qsTr("相关性显示")
            }

        }
    }
    GroupBox{
        Layout.fillWidth: true
        Layout.preferredHeight: parent.height*0.9
        StockData{
            id:corrTable
            sdata:""
        }
    }

}

