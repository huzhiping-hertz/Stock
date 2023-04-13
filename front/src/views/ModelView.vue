<template>
    <LayoutMain>

        <SectionMain>


            <CardBox class="mb-6 ">
                <el-form :inline="true" :model="formInline" class="demo-form-inline">
                    <el-form-item label="模型">
                        <el-select v-model="modelName" placeholder="Select" size="large">
                            <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value" />
                        </el-select>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="onChange" size="large">查看</el-button>
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
import { getModels, getModelByName } from '@/api/DataModel';

const domChart = ref(null);
let chart;

const selectdModel = ref('');
const options = ref([]);
let rs = getModels();
const infos = ref("");
const modelName = ref();

function onChange() {

    getModelByName(modelName.value).then((response) => {

        const obj = JSON.parse(response.data);
        if (obj.length > 0) {
            let modelPoints = obj[0].data.split(",");
            chart = echarts.init(unref(domChart), 'dark');
            var option;

            option = {
                tooltip: {
                    trigger: 'axis'
                },
                xAxis: {
                    type: 'category',
                    min: 0,
                    max: modelPoints.lenght
                },
                yAxis: {
                    type: 'value'
                },
                series: [
                    {
                        data: modelPoints,
                        type: 'line',
                        markPoint: {
                            data: [
                                { type: 'max', name: 'Max' },
                                { type: 'min', name: 'Min' }
                            ]
                        },
                        markLine: {
                            data: [{ type: 'average', name: 'Avg' }]
                        }
                    }
                ]
            };

            option && chart.setOption(option);
        }

    });

}

onMounted(() => {


    getModels().then((response) => {
        const obj = JSON.parse(response.data);
        obj.forEach(item => {
            options.value.push({ "value": item.name, "label": item.name })
        });
    });


});

</script>