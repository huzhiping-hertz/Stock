<template>
    <LayoutMain>

        <SectionMain>


            <CardBox class="mb-12 ">

                <el-form :inline="true" :model="formInline" class="demo-form-inline">
                    <el-form-item label="数据模型">
                        <el-select v-model="mid" placeholder="Select" size="large">
                            <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value" />
                        </el-select>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="onChange" size="large">查看模型</el-button>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="onDelete" size="large">删除模型</el-button>
                    </el-form-item>
                </el-form>

            </CardBox>

        </SectionMain>

        <SectionMain>


            <CardBox class="mb-6">
                <div ref="domChart" style="height: 500px;"></div>
            </CardBox>

        </SectionMain>

    </LayoutMain>
</template>

<script setup>
import LayoutMain from "@/layouts/LayoutMain.vue";
import SectionMain from "@/components/SectionMain.vue";
import CardBox from "@/components/CardBox.vue";
import * as echarts from 'echarts';
import { ref, unref, onMounted, reactive } from 'vue'
import { getModels, getModelById, delModelById,updateModel } from '@/api/DataModel';
import { RouterView, useRouter } from "vue-router";
import { ElMessage } from 'element-plus'

const domChart = ref(null);
let myChart;
let data = []
const selectdModel = ref('');
const options = ref([]);
let rs = getModels();
const infos = ref("");
const mid = ref();
const router = new useRouter();

function onChange() {

    getModelById(mid.value).then((response) => {

        const obj = JSON.parse(response.data);

        if (obj.length > 0) {
            let rawData = obj[0].data.split(",");
            myChart = echarts.init(unref(domChart), 'dark');
            var symbolSize = 20;

            data = []
            rawData.forEach((val, index) => {
                data.push([index, parseFloat(val)])
            })

            console.log(data)

            myChart.setOption({
                tooltip: {
                    triggerOn: 'none',
                    formatter: function (params) {
                        return (
                            'X: ' +
                            params.data[0].toFixed(2) +
                            '<br />Y: ' +
                            params.data[1].toFixed(2)
                        );
                    }
                },
                toolbox: {
                    feature: {
                        myModel: {
                            show: true,
                            title: "保存更改",
                            icon: 'path://M10.7,11.9v-1.3H9.3v1.3c-4.9,0.3-8.8,4.4-8.8,9.4c0,5,3.9,9.1,8.8,9.4v1.3h1.3v-1.3c4.9-0.3,8.8-4.4,8.8-9.4C19.5,16.3,15.6,12.2,10.7,11.9z M13.3,24.4H6.7V23h6.6V24.4z M13.3,19.6H6.7v-1.4h6.6V19.6z',
                            onclick: function () {

                                var normal_data = data.map(item => (item[1]).toFixed(2))
                                normal_data = normal_data.toString()
                                updateModel(mid.value, normal_data).then((rs) => {
                                    updateModelInfo()
                                    
                                })

                            }
                        },
                    }
                },
                xAxis: { min: 0, max: data.length, type: 'value', axisLine: { onZero: false } },
                yAxis: { min: 0, max: 1, type: 'value', axisLine: { onZero: false } },
                series: [
                    { id: 'a', type: 'line', smooth: true, symbolSize: symbolSize, data: data }
                ]
            });
            myChart.setOption({
                graphic: echarts.util.map(data, function (item, dataIndex) {
                    return {
                        type: 'circle',
                        position: myChart.convertToPixel('grid', item),
                        shape: { r: symbolSize / 2 },
                        invisible: true,
                        draggable: true,
                        ondrag: echarts.util.curry(onPointDragging, dataIndex),
                        onmousemove: echarts.util.curry(showTooltip, dataIndex),
                        onmouseout: echarts.util.curry(hideTooltip, dataIndex),
                        z: 100
                    };
                })
            });
            window.addEventListener('resize', function () {
                myChart.setOption({
                    graphic: echarts.util.map(data, function (item, dataIndex) {
                        return { position: myChart.convertToPixel('grid', item) };
                    })
                });
            });
            function showTooltip(dataIndex) {
                myChart.dispatchAction({
                    type: 'showTip',
                    seriesIndex: 0,
                    dataIndex: dataIndex
                });
            }
            function hideTooltip(dataIndex) {
                myChart.dispatchAction({ type: 'hideTip' });
            }
            function onPointDragging(dataIndex, dx, dy) {
                var tmp = myChart.convertFromPixel('grid', this.position);
                data[dataIndex][1] = tmp[1];
                this.position = myChart.convertToPixel('grid', data[dataIndex]),
                    myChart.setOption({
                        series: [
                            {
                                id: 'a',
                                data: data
                            }
                        ]
                    });
            }


        }

    });

}


function onDelete() {
    delModelById(mid.value).then((response) => {
        InitModel()
        deleteModelInfo()
    })
}

function InitModel() {
    options.value.splice(0, options.value.length)
    getModels().then((response) => {
        const obj = JSON.parse(response.data);
        obj.forEach(item => {
            options.value.push({ "value": item.id, "label": item.name })
        });
        mid.value = options.value[0].value
    });
}
const deleteModelInfo = () => {
    ElMessage({
        message: '删除成功！',
        type: 'success',
    })
}
const updateModelInfo = () => {
    ElMessage({
        message: '更新成功！',
        type: 'success',
    })
}
onMounted(() => {


    InitModel()


});

</script>

