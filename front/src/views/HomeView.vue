<template>
    <LayoutMain>

        <SectionMain>

            <CardBox class="mb-6">

                <el-form :inline="true" :model="formInline" class="demo-form-inline">
                    <el-form-item label="开始时间">
                        <el-date-picker v-model="dateStart" type="date" placeholder="Pick a day" size="large"
                            value-format="YYYYMMDD" />
                    </el-form-item>
                    <el-form-item label="结束时间">
                        <el-date-picker v-model="dateStop" type="date" placeholder="Pick a day" size="large"
                            value-format="YYYYMMDD" />
                    </el-form-item>
                    <el-form-item label="股票代码">
                        <el-select v-model="scode" placeholder="Select" size="large">
                            <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item" />
                        </el-select>
                    </el-form-item>
                    <el-form-item label="数据模型">
                        <el-select v-model="cmodel" placeholder="Select" size="large">
                            <el-option v-for="item in modelOptions" :key="item.value" :label="item.label"
                                :value="item.value" />
                        </el-select>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="onSearch" size="large">数据查看</el-button>
                    </el-form-item>
                </el-form>

            </CardBox>

        </SectionMain>

        <SectionMain>

            <!-- 
            <CardBox class="mb-6">
                <CandalStick />
            </CardBox> -->

            <CardBox class="mb-6">
                <div ref="domChart" style="height: 600px;"></div>
            </CardBox>

        </SectionMain>

    </LayoutMain>
</template>

<script setup>
import * as echarts from 'echarts';
import LayoutMain from "@/layouts/LayoutMain.vue";
import SectionMain from "@/components/SectionMain.vue";
import CardBox from "@/components/CardBox.vue";
import CandalStick from "@/components/Stocks/CandalStick.vue";
import { getStockCodes, getStockData } from '@/api/StockCodesApi';
import { getModels, getModelById, saveModel } from '@/api/DataModel';
import { RouterView, useRouter } from "vue-router";
import { ref, unref, watch, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

const dateStart = ref('')
const dateStop = ref('')
const scode = ref()
const cmodel = ref()
const options = ref([]);
const modelOptions = ref([]);
const router = useRouter();
const dialogFormVisible = ref(false)
const model_name = ref()

const props = defineProps({
    data: {
        type: Object,
        required: true,
    },
});

const domChart = ref(null);
let chart;

let modelMin = 0;
let modelMax = 0;
let pts;


function onSearch() {

    getStockData(scode.value.value, dateStart.value, dateStop.value, cmodel.value).then((response) => {

        const rawData = JSON.parse(response.data)
        //初始化图表
        chart = echarts.init(unref(domChart), 'dark');
        var option;

        function calculateMA(dayCount, data) {
            var result = [];
            for (var i = 0, len = data.length; i < len; i++) {
                if (i < dayCount) {
                    result.push('-');
                    continue;
                }
                var sum = 0;
                for (var j = 0; j < dayCount; j++) {
                    sum += +data[i - j][1];
                }
                result.push((sum / dayCount).toFixed(2));
            }
            return result;
        }

        const dates = rawData.map(function (item) {
            return item[0].substr(0, 4) + "-" + item[0].substr(4, 2) + "-" + item[0].substr(6, 2);
        });
        const datestr = rawData.map(function (item) {
            return item[0];
        });

        const dataclose = rawData.map(function (item) {
            return item[2];
        });

        const data = rawData.map(function (item) {
            return [+item[1], +item[2], +item[3], +item[4]];
        });

        const pcorr = rawData.map(function (item) {
            return item[5].toFixed(2);
        });
        const scorr = rawData.map(function (item) {
            return item[6].toFixed(2);
        });
        const kcorr = rawData.map(function (item) {
            return item[7].toFixed(2);
        });

        option = {
            legend: {
                data: ['日K', '5日均线', '10日均线', '20日均线', '皮尔逊相关性', '斯皮尔曼相关性', '肯德尔相关性'],
                inactiveColor: '#777'
            },
            tooltip: {
                trigger: 'axis',
                axisPointer: {
                    animation: true,
                    type: 'cross',
                    lineStyle: {
                        color: '#376df4',
                        width: 2,
                        opacity: 1
                    }
                }
            },
            axisPointer: {
                link: [
                    {
                        xAxisIndex: 'all'
                    }
                ],
                label: {
                    backgroundColor: '#777'
                }
            },
            dataZoom: [
                {
                    type: 'inside',
                    xAxisIndex: [0, 1],
                },
                {
                    show: true,
                    xAxisIndex: [0, 1],
                    type: 'slider',

                }
            ],
            grid: [
                {
                    left: 50,
                    right: 50,
                    height: '35%'
                },
                {
                    left: 50,
                    right: 50,
                    top: '55%',
                    height: '35%'
                }
            ],
            toolbox: {
                feature: {


                    brush: {
                        type: ['lineX']
                    },
                    myModel: {
                        show: true,
                        title: "Save Data As Model",
                        icon: 'path://M10.7,11.9v-1.3H9.3v1.3c-4.9,0.3-8.8,4.4-8.8,9.4c0,5,3.9,9.1,8.8,9.4v1.3h1.3v-1.3c4.9-0.3,8.8-4.4,8.8-9.4C19.5,16.3,15.6,12.2,10.7,11.9z M13.3,24.4H6.7V23h6.6V24.4z M13.3,19.6H6.7v-1.4h6.6V19.6z',
                        onclick: function () {

                            var mdata = dataclose.slice(pts[0], pts[pts.length])
                            var min = Math.min(...mdata)
                            var max = Math.max(...mdata)
                            var normal_data = mdata.map(x => ((x - min) / (max - min)).toFixed(2))
                            normal_data = normal_data.toString()

                            ElMessageBox.prompt('输入模型名称', '', {
                                confirmButtonText: 'OK',
                                cancelButtonText: 'Cancel'
                            }).then(({ value }) => {

                                saveModel(value, normal_data).then((rs) => {
                                    //router.push("/Model")
                                    InitModel()

                                    // ElMessage({
                                    //     type: 'success',
                                    //     message: `Your email is:${value}`,
                                    // })
                                })
                            })



                        }
                    },
                }
            },
            brush: {

                xAxisIndex: 'all',
                brushLink: 'all',
                outOfBrush: {
                    colorAlpha: 0.1
                }
            },
            xAxis: [
                {
                    type: 'category',
                    boundaryGap: false,
                    axisLine: { lineStyle: { color: '#8392A5' } },
                    data: dates
                },
                {
                    gridIndex: 1,
                    type: 'category',
                    boundaryGap: false,
                    axisLabel: { show: false },
                    axisLine: { show: false },
                    axisTick: { show: false },
                    splitLine: { show: false }

                }
            ],
            yAxis: [
                {
                    scale: true,
                    axisLine: { lineStyle: { color: '#8392A5' } },
                    splitLine: { show: true }
                },
                {
                    gridIndex: 1,
                    type: 'value',
                    inverse: false
                }
            ],
            series: [
                {
                    type: 'candlestick',
                    name: 'Day',
                    data: data,
                    itemStyle: {
                        color: '#FD1050',
                        color0: '#0CF49B',
                        borderColor: '#FD1050',
                        borderColor0: '#0CF49B'
                    }
                },
                {
                    name: '5日均线',
                    type: 'line',
                    data: calculateMA(5, data),
                    smooth: true,
                    showSymbol: false,
                    lineStyle: {
                        width: 1
                    }
                },
                {
                    name: '10日均线',
                    type: 'line',
                    data: calculateMA(10, data),
                    smooth: true,
                    showSymbol: false,
                    lineStyle: {
                        width: 1
                    }
                },
                {
                    name: '20日均线',
                    type: 'line',
                    data: calculateMA(20, data),
                    smooth: true,
                    showSymbol: false,
                    lineStyle: {
                        width: 1
                    }
                },
                {
                    name: '皮尔逊相关性',
                    type: 'line',
                    xAxisIndex: 1,
                    yAxisIndex: 1,
                    symbolSize: 5,
                    lineStyle: {
                        width: 1
                    },
                    markPoint: {
                        data: [
                            { type: 'max', name: 'Max' },
                            { type: 'min', name: 'Min' }
                        ]
                    },
                    data: pcorr,
                },
                {
                    name: '斯皮尔曼相关性',
                    type: 'line',
                    xAxisIndex: 1,
                    yAxisIndex: 1,
                    symbolSize: 5,
                    lineStyle: {
                        width: 1
                    },
                    markPoint: {
                        data: [
                            { type: 'max', name: 'Max' },
                            { type: 'min', name: 'Min' }
                        ]
                    },
                    data: scorr,
                },
                {
                    name: '肯德尔相关性',
                    type: 'line',
                    xAxisIndex: 1,
                    yAxisIndex: 1,
                    symbolSize: 5,
                    lineStyle: {
                        width: 1
                    },
                    markPoint: {
                        data: [
                            { type: 'max', name: 'Max' },
                            { type: 'min', name: 'Min' }
                        ]
                    },
                    data: kcorr,
                }
            ]
        };
        option && chart.setOption(option);

        chart.on('brushSelected', function (params) {
            // this shows an empty array - while it should be the range selected
            pts = params.batch[0].selected[0].dataIndex;
            modelMin = datestr[pts[0]];
            modelMax = datestr[pts[pts.length - 1]]
            console.log(modelMin + "-" + modelMax)
        });

    })

}

function InitModel() {
    modelOptions.value.splice(0, modelOptions.value.length)
    getModels().then((response) => {
        const obj = JSON.parse(response.data);
        obj.forEach(item => {
            modelOptions.value.push({ "value": item.id, "label": item.name })
        });
        cmodel.value = modelOptions.value[0].value
    });
}

onMounted(() => {

    var now = new Date();
    var month = (now.getMonth() + 1) > 9 ? now.getMonth() + 1 : "0" + (now.getMonth() + 1);
    var date = now.getDate() > 9 ? now.getDate() : "0" + now.getDate();
    dateStop.value = now.getFullYear() + "" + month + "" + date;
    dateStart.value = now.getFullYear() - 1 + "" + month + "" + date;


    getStockCodes().then((response) => {

        const obj = JSON.parse(response.data);
        obj.forEach(item => {
            options.value.push({ "value": item.ts_code, "label": item.name })
        });
        scode.value = options.value[0]
    });

    InitModel()
    // getModels().then((response) => {
    //     const obj = JSON.parse(response.data);
    //     obj.forEach(item => {
    //         modelOptions.value.push({ "value": item.id, "label": item.name })
    //     });
    //     cmodel.value = modelOptions.value[0].value
    // });



});
</script>