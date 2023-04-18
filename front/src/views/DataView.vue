
<template>
    <LayoutMain>

        <SectionMain>


            <CardBox class="mb-6">
                <FormField label="">
                    <el-form :inline="true" :model="formInline" class="demo-form-inline">
                        <el-form-item label="开始时间">
                            <el-date-picker v-model="dateStart" type="date" placeholder="Pick a day" size="large"  value-format="YYYYMMDD"/>
                        </el-form-item>
                        <el-form-item label="结束时间">
                            <el-date-picker v-model="dateStop" type="date" placeholder="Pick a day" size="large" value-format="YYYYMMDD"/>
                        </el-form-item>
                        <el-form-item label="股票代码">
                            <el-select v-model="codes" multiple placeholder="Select" filterable size="large" @change="onCodeChange">
                                <el-option v-for="item in options" :key="item.value" :label="item.label"
                                    :value="item.value" />
                            </el-select>
                        </el-form-item>
                        <el-form-item>
                            <el-button type="primary" @click="onSyncData" size="large">数据同步</el-button>
                        </el-form-item>
                    </el-form>

                </FormField>

            </CardBox>

            <CardBox class="mb-6">
                <el-progress :text-inside="true" :stroke-width="26" :percentage="percent" />               
            </CardBox>
        </SectionMain>


    </LayoutMain>
</template>
<script setup>
import LayoutMain from "@/layouts/LayoutMain.vue";
import SectionMain from "@/components/SectionMain.vue";
import CardBox from "@/components/CardBox.vue";
import FormField from "@/components/FormField.vue";
import {getStockCodes,syncStockData} from '@/api/StockCodesApi';

import { onMounted, ref } from 'vue'

var dateStart=ref('');
var dateStop=ref('');
const options=ref([])
const codes=ref()
const percent=ref(0)

function onCodeChange()
{
    percent.value=0;
}

function onSyncData()
{
    codes.value.forEach((item,index)=>{

        syncStockData(item,dateStart.value,dateStop.value).then((response)=>{

            percent.value=100*(index+1)/codes.value.length
        })

    })
}

onMounted(()=>{
    var now=new Date();
    var month=(now.getMonth()+1)>9?now.getMonth()+1:"0"+(now.getMonth()+1);
    var date=now.getDate()>9?now.getDate():"0"+now.getDate();
    dateStop.value=now.getFullYear()+""+month+""+date;
    dateStart.value=now.getFullYear()-1+""+month+""+date;

    getStockCodes().then((response)=>{

        const obj = JSON.parse(response.data);
        obj.forEach(item => {
            options.value.push({ "value": item.ts_code, "label": item.name })
        });
    });

});



</script>