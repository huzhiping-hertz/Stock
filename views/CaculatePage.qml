import QtQuick 2.15
import QtCharts 2.3
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQml.Models
import QtQuick.Controls.Material
import Qt.labs.qmlmodels 1.0

import RS.Controllers.CaculateController 1.0


ColumnLayout {
    anchors.fill: parent

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
    }
    GroupBox {
        Layout.fillWidth: true
        Layout.preferredHeight: parent.height*0.1
        Row{
            anchors.fill: parent
            spacing: 10
            Control{
                width: 350
                height: parent.height
                ComboBox {
                    id:modelNames
                }
            }

            Control{
                width: 100
                height: parent.height
                Button {
                    text: "查看"
                    anchors.centerIn: parent
                    onClicked:{
                        //stockview.changeData(datastr);
                        rschart.removeAllSeries();
                        rschart.axisX(axisX)
                        rschart.axisY(axisY)
                    
                        var datastr=modelCtl.getDataByName(modelNames.currentValue)
                        console.log(datastr)
                        var record=JSON.parse(datastr)[0]
                        var line = rschart.createSeries(ChartView.SeriesTypeLine, record["name"],axisX,axisY);
                        var vals=record["data"].split(",")
                        vals.forEach(function(item,index){
                            line.append(index,item);
                        })
                        axisX.min = 0;
                        axisX.max = vals.length-1;
                        axisY.min = 0;
                        axisY.max = 1.2;
                        axisX.tickCount=vals.length-1;

                    }
                }
            }

        }
    }
 
    GroupBox {
        Layout.fillWidth: true
        Layout.preferredHeight: parent.height*0.9
        ChartView{
            id:rschart
            anchors.fill: parent
            theme: ChartView.ChartThemeDark
            legend.alignment: Qt.AlignRight
            ValueAxis {
                id: axisY
                gridVisible: true
                tickInterval: 1
                gridLineColor: 'grey'
                labelFormat: "%.2f"
            }

            ValueAxis {
                id: axisX
                gridVisible: true
                tickInterval:1
                gridLineColor: 'grey'
                tickType: ValueAxis.TicksFixed
                labelFormat: "%d"
            }

        }
    }


}

