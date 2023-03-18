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
        records.forEach(function(item,index){
            names.push(item[0]);
        });
        print(names)
        stockCodes.model=names;
    }
    GroupBox {
        Layout.fillWidth: true
        Layout.preferredHeight: parent.height*0.1
        RowLayout{
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
                    text:"2022-02-01"
                    placeholderText: qsTr("2022-03-01")
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
                width: 50
                height: parent.height
                Label {
                    
                    anchors.centerIn: parent
                    text: "代码"
                }
            }
                
            ComboBox {
                width: 300
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
            
                
            CheckBox {
                    width: 150
                height: parent.height
                    id:unite
                    checked: false
                    text: qsTr("归一化(min-max)")
                }
            
            CheckBox {
                    width: 150
                    height: parent.height
                    id:corrshow
                    checked: false
                    text: qsTr("相关性显示")
                }
            
            Control{
                width: 100
                height: parent.height
                Button {
                    text: "查看"
                    anchors.centerIn: parent
                    onClicked:{


                        //stockview.changeData(datastr);
                        //chart.removeAllSeries();
                        chart.axisX(axisX)
                        chart.axisY(axisY)
                        stockLine.removePoints(0,stockLine.count)
                        corrLine.removePoints(0,corrLine.count)
                        var xmax;
                        var ymax=0;

                        // var start = new Date(startDate.text); 
                        // var stop = new Date(stopDate.text);

                        // var difference= Math.abs(stop-start);
                        // var num = difference/(1000 * 3600 * 24)
                        var num=0;
                        var start=String(startDate.text);
                        var stop=String(stopDate.text);
                        print(stockCodes.currentValue)
                        var stocks=new Array();
                        stocks.push(stockCodes.currentValue)
                        stocks.forEach(function(item){

                            print(item)

                            var datastr=stockCtl.getData(item,start.replace(/-/g,""),stop.replace(/-/g,""))
                            //var line = stockLines.createSeries(ChartView.SeriesTypeLine, item,axisX,axisY);
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
                                    //line.append(index,(item["pre_close"]-min_price)/(max_price-min_price));
                                    stockLine.append(index,(item["pre_close"]-min_price)/(max_price-min_price));
                                })
                                

                                if(corrshow.checked==true)
                                {
                                    var corrstr=caculateCtl.correlation_pearson(item,start.replace(/-/g,""),stop.replace(/-/g,""),"pre_close",modelNames.currentValue);
                                    //console.log(corrstr);
                                    var corrpoints=JSON.parse(corrstr)
                                    //var corrline = stockLines.createSeries(ChartView.SeriesTypeLine, "Corr-"+item,axisX,axisY);
                                    corrpoints.forEach(function(item,index){
                                        corrLine.append(index,item["pre_close"]);
                                    })
                                }

                            }
                            else{
                                records.forEach(function(item,index){
                                    //line.append(index,item["pre_close"]);
                                    //scatter.append(index,item["pre_close"]);
                                    stockLine.append(index,item["pre_close"]);
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
            id:chart
            anchors.fill: parent
            theme: ChartView.ChartThemeDark
            legend.visible:false

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

            ToolTip{
                id:toolTip
                delay: 4
                font.family: "微软雅黑"
                font.bold: true
                font.pointSize: 13
            }
            LineSeries{
                id:stockLine
                axisX: axisX
                axisY: axisY
                onHovered: {
                    var chartPosition = chart.mapToPosition(point,stockLine)
                    myCanvas.xx = chartPosition.x
                    myCanvas.yy = chartPosition.y
                    console.log(myCanvas.xx)
                    console.log(myCanvas.yy)
                    console.log(state)
                    toolTip.visible = state
                    toolTip.text = "X："+point.x.toFixed(0)+"  Y："+point.y.toFixed(2)
                    toolTip.x = chartPosition.x+10
                    toolTip.y = chartPosition.y-40
                    var d = new Date()
                    myCanvas.requestPaint()
                }
            }
            LineSeries{
                id:corrLine
                axisX: axisX
                axisY: axisY
                onHovered: {
                    var chartPosition = chart.mapToPosition(point,corrLine)
                    myCanvas.xx = chartPosition.x
                    myCanvas.yy = chartPosition.y
                    toolTip.visible = state
                    toolTip.text = "X："+point.x.toFixed(0)+"  Y："+point.y.toFixed(2)
                    toolTip.x = chartPosition.x+10
                    toolTip.y = chartPosition.y-40
                    var d = new Date()
                    myCanvas.requestPaint()
                }
            }
            Canvas{
                id:myCanvas
                anchors.fill: chart
                property double xx: 0
                property double yy: 0
                onPaint: {
                    if(xx+yy>0){
                        var ctx = getContext("2d")//绘制十字交叉的竖线
                        ctx.clearRect(0,0,parent.width,parent.height)
                        ctx.strokeStyle = '#66ffff00'
                        ctx.lineWidth = 3
                        ctx.beginPath()
                        ctx.moveTo(xx,chart.plotArea.y)
                        ctx.lineTo(xx,chart.plotArea.height+chart.plotArea.y)
                        ctx.stroke()
                        ctx.beginPath()//绘制十字交叉的横线
                        ctx.moveTo(chart.plotArea.x,yy)
                        ctx.lineTo(chart.plotArea.x+chart.plotArea.width,yy)
                        ctx.stroke()
                    }else{//鼠标离开图表区域时，清除十字线
                        var ctx = getContext("2d")
                        ctx.clearRect(0,0,parent.width,parent.height)
                    }
                }
            }

        }
    }


}

