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
                    text: "开始"
                }
            }
            Control{
                width: 100
                height: parent.height
                TextField {
                    id:startDate
                    anchors.centerIn: parent
                    text:"2023-02-01"
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
            Control{
                width: 120
                height: parent.height
                Label {
                    
                    anchors.centerIn: parent
                    text: "代码(逗号分割)"
                }
            }
            Control{
                width: 300
                height: parent.height
                TextField {
                    id:stockCodes
                    width:parent.width
                    anchors.centerIn: parent
                    text:"000001.SZ,000002.SZ"
                    placeholderText: qsTr("000001.SZ,000002.SZ")
                }
            }
            Control{
                width: 50
                height: parent.height
                Label {
                    
                    anchors.centerIn: parent
                    text: "数据模型"
                }
            }
            Control{
                width: 120
                height: parent.height
                ComboBox {
                    id:modelNames
                }
            }
            Control{
                width: 150
                height: parent.height
                CheckBox {
                        id:unite
                        checked: false
                        text: qsTr("归一化(min-max)")
                    }
            }
            Control{
                width: 150
                height: parent.height
                CheckBox {
                        id:corrshow
                        checked: false
                        text: qsTr("相关性显示")
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
                        stockLines.removeAllSeries();
                        stockLines.axisX(axisX)
                        stockLines.axisY(axisY)

                        var xmax;
                        var ymax=0;

                        // var start = new Date(startDate.text); 
                        // var stop = new Date(stopDate.text);

                        // var difference= Math.abs(stop-start);
                        // var num = difference/(1000 * 3600 * 24)
                        var num=0;
                        var start=String(startDate.text);
                        var stop=String(stopDate.text);
                        var stocks=stockCodes.text.split(",")
                        stocks.forEach(function(item){



                            var datastr=stockCtl.getData(item,start.replace(/-/g,""),stop.replace(/-/g,""))
                            var line = stockLines.createSeries(ChartView.SeriesTypeLine, item,axisX,axisY);
                            //var scatter = stockLines.createSeries(ChartView.SeriesTypeScatter, "",axisX,axisY);
                            console.log(datastr)
                            var records=JSON.parse(datastr)
                            if(records.length>num)
                            {
                                num=records.length
                            }

                            if(unite.checked==true)
                            {
                                var max_price=0;
                                var min_price=100000;
                                records.forEach(function(item,index){
                                    if(item["pre_close"]>max_price)
                                    {
                                        max_price=item["pre_close"];
                                    }
                                    if(item["pre_close"]<min_price)
                                    {
                                        min_price=item["pre_close"];
                                    }
                                })
                                records.forEach(function(item,index){
                                    line.append(index,(item["pre_close"]-min_price)/(max_price-min_price));
                                })

                                if(corrshow.checked==true)
                                {
                                    var corrstr=caculateCtl.correlation_pearson(item,start.replace(/-/g,""),stop.replace(/-/g,""),"pre_close",modelNames.currentValue);
                                    //console.log(corrstr);
                                    var corrpoints=JSON.parse(corrstr)
                                    var corrline = stockLines.createSeries(ChartView.SeriesTypeLine, "Corr-"+item,axisX,axisY);
                                    corrpoints.forEach(function(item,index){
                                        corrline.append(index,item["pre_close"]);
                                    })
                                }

                            }
                            else{
                                records.forEach(function(item,index){
                                    line.append(index,item["pre_close"]);
                                    //scatter.append(index,item["pre_close"]);
                                    if(item["pre_close"]>ymax)
                                    {
                                        ymax=item["pre_close"];
                                    }
                                })
                            } 
                        });
                        
                        axisX.min = 0;
                        axisX.max = num-1;
                        axisY.min = 0;
                        axisY.max = 1.3*ymax;
                        axisX.tickCount=num;
                        if(unite.checked==true)
                        {
                            axisY.max=1.2
                            axisY.tickCount=20
                        }
                        if(corrshow.checked==true)
                        {
                            axisY.min=-1;
                        }


                    }
                }
            }

        }
    }
 
    // GroupBox {
    //     Layout.fillWidth: true
    //     Layout.preferredHeight: parent.height*0.3
    //     StockData{
    //         id:stockview
    //         sdata:""
    //     }

    // }
    GroupBox {
        Layout.fillWidth: true
        Layout.preferredHeight: parent.height*0.9
        ChartView{
            id:stockLines
            anchors.fill: parent
            theme: ChartView.ChartThemeDark
            legend.alignment: Qt.AlignRight
            ValueAxis {
                id: axisY
                gridVisible: true
                tickInterval: 1
                gridLineColor: "#33c0c0c0"
                labelFormat: "%.2f"
            }

            ValueAxis {
                id: axisX
                gridVisible: true
                tickInterval:1
                gridLineColor: "#33c0c0c0"
                tickType: ValueAxis.TicksFixed
                labelFormat: "%d"
            }

        }
    }


}

