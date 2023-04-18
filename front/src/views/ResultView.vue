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
            <el-select v-model="cmodel" placeholder="Select" size="large">
              <el-option v-for="item in modelOptions" :key="item.value" :label="item.label" :value="item.value" />
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
          <el-table-column label="价格" prop="pre_close_x" />
          <el-table-column label="交易日期" prop="trade_date" />
          <el-table-column label="模型相关性" prop="pre_close_y" sortable />

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
import { getStockCodes, getStockData, getStockCorr } from '@/api/StockCodesApi';
import { getModels, getModelByName } from '@/api/DataModel';

const codes = ref()
const cmodel = ref()
const options = ref([]);
const modelOptions = ref([]);

const tableData = ref([])

function onCaculate() {
  tableData.value=[]
  codes.value.forEach((item, index) => {

    getStockCorr(item.value, cmodel.value).then((response) => {

      var row=JSON.parse(response.data)
      row.scode=item.value
      row.sname=item.label
      tableData.value.push(row)

    })

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
      modelOptions.value.push({ "value": item.name, "label": item.name })
    });
  });



});
</script>