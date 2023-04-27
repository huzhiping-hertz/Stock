<template>
  <LayoutMain>

    <SectionMain>


      <CardBox class="mb-6">
        <el-form :inline="true" :model="formInline" class="demo-form-inline">
          <el-form-item label="股票代码">
            <el-select v-model="codes" placeholder="Select" size="large" multiple>
              <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item" />
            </el-select>
          </el-form-item>
          <el-form-item label="数据模型">
            <el-select v-model="cmodels" placeholder="Select" size="large" @change="onModelChanged" multiple>
              <el-option v-for="item in modelOptions" :key="item.value" :label="item.label" :value="item" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="onCaculate" size="large">相关性计算</el-button>
          </el-form-item>
        </el-form>

      </CardBox>

    </SectionMain>

    <SectionMain>


      <CardBox class="mb-6">
        <el-table :data="tableData" :default-sort="{ prop: 'corr', order: 'descending' }" style="width: 100%">
          <el-table-column label="股票名称" prop="sname" />
          <el-table-column label="股票代码" prop="scode" />
          <el-table-column label="收盘价格" prop="close" />
          <el-table-column label="交易日期" prop="trade_date" />

          
          <el-table-column v-for="column in columns" 
                     :key="column.prop"
                     :prop="column.prop"
                     :label="column.label" sortable>
          </el-table-column>
          <el-table-column label="总计" prop="sum" sortable />
        </el-table>
      </CardBox>

    </SectionMain>

  </LayoutMain>
</template>

<script  setup>
import LayoutMain from "@/layouts/LayoutMain.vue";
import SectionMain from "@/components/SectionMain.vue";
import CardBox from "@/components/CardBox.vue";
import { ref, unref, onMounted, computed } from 'vue'
import { getStockCodes, getStockData, getStockCorr,getStockCorrelations } from '@/api/StockCodesApi';
import { getModels, getModelById } from '@/api/DataModel';

const codes = ref()
const columns=ref([])
const cmodels = ref()
const options = ref([]);
const modelOptions = ref([]);

const tableData = ref([])

function onModelChanged(){
  columns.value=[]
  cmodels.value.forEach((cmodel, index) => {
    
    columns.value.push({"label":cmodel.label,"prop":"close_"+cmodel.value})
  })

}

function onCaculate() {
  tableData.value = []
  let models=[]
  cmodels.value.forEach((cmodel, index) => {
    models.push(cmodel.value)
  })
  codes.value.forEach((item, index) => {

      getStockCorrelations(item.value,models.toString()).then((response)=>{
            var row = JSON.parse(response.data)
            row.scode = item.value
            row.sname = item.label
            tableData.value.push(row)
      })
    // cmodels.value.forEach((cmodel, cindex) => {
    //   getStockCorr(item.value, cmodel.value).then((response) => {

    //     var row = JSON.parse(response.data)
    //     row.scode = item.value
    //     row.sname = item.label
    //     row.mname=cmodel.label
    //     tableData.value.push(row)

    //   })
    // })

  })
}

onMounted(() => {


  getStockCodes().then((response) => {

    const obj = JSON.parse(response.data);
    obj.forEach(item => {
      options.value.push({ "value": item.ts_code, "label": item.name })
    });
  });

  getModels().then((response) => {
    const obj = JSON.parse(response.data);
    obj.forEach(item => {
      modelOptions.value.push({ "value": item.id, "label": item.name })
    });
  });



});
</script>