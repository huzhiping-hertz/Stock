<template>
  <LayoutMain>

    <SectionMain>


      <CardBox class="mb-6">
        <el-form :inline="true" :model="formInline" class="demo-form-inline">
          <el-form-item label="股票代码">
            <el-select v-model="codes" placeholder="Select" size="large" multiple filterable>
              <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item" />
            </el-select>
          </el-form-item>
          <el-form-item label="数据模型">
            <el-select v-model="cmodel" placeholder="Select" size="large">
              <el-option v-for="item in modelOptions" :key="item.value" :label="item.label" :value="item.value" />
            </el-select>
          </el-form-item>
          <el-form-item label="数据列">
            <el-select v-model="scolumns" placeholder="Select" size="large" multiple>
              <el-option v-for="item in columns" :key="item.value" :label="item.label" :value="item" />
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
          <!-- <el-table-column label="股票代码" prop="scode" /> -->
          <el-table-column label="交易日期" prop="trade_date" />

          <!-- <el-table-column label="股票信息" fixed="right">
            <el-table-column label="开盘价" prop="open" sortable/>
            <el-table-column label="收盘价" prop="close" sortable/>
            <el-table-column label="最高价" prop="high" sortable/>
            <el-table-column label="最低价" prop="low" sortable/>
            <el-table-column label="7日" prop="close_7_avg" sortable/>
            <el-table-column label="29日" prop="close_29_avg" sortable/>
            <el-table-column label="89日" prop="close_89_avg" sortable/>
            <el-table-column label="344日" prop="close_344_avg" sortable/>
          </el-table-column>

          <el-table-column label="相关系数" fixed="right">

            <el-table-column label="开盘" prop="open_c" sortable/>
            <el-table-column label="收盘" prop="close_c" sortable/>
            <el-table-column label="最高" prop="high_c" sortable/>
            <el-table-column label="最低" prop="low_c" sortable/>
            <el-table-column label="7日" prop="close_7_avg_c" sortable/>
            <el-table-column label="29日" prop="close_29_avg_c" sortable/>
            <el-table-column label="89日" prop="close_89_avg_c" sortable/>
            <el-table-column label="344日" prop="close_344_avg_c" sortable/>
            <el-table-column label="系数总计" prop="sum" sortable />
          </el-table-column> -->
          <el-table-column label="股票信息" fixed="right">
            <el-table-column v-for="column in scolumns" :key="column.value" :prop="column.value" :label="column.label"
              sortable>
            </el-table-column>
          </el-table-column>
          <el-table-column label="相关系数" fixed="right">
            <el-table-column v-for="column in scolumns" :key="column.cvalue" :prop="column.cvalue" :label="column.label"
              sortable>
            </el-table-column>
            <el-table-column label="总计" prop="total" sortable />
          </el-table-column>
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
import { getStockCodes, getStockData, getStockCorr, getStockCorrelations } from '@/api/StockCodesApi';
import { getModels, getModelById } from '@/api/DataModel';

const codes = ref()

const cmodel = ref()
const options = ref([]);
const modelOptions = ref([]);

const tableData = ref([])

const columns = [

  { "label": "开盘", "value": "open" ,"cvalue":"open_c"},
  { "label": "收盘", "value": "close","cvalue":"close_c" },
  { "label": "最高", "value": "high","cvalue":"high_c" },
  { "label": "最低", "value": "low" ,"cvalue":"low_c"},
  { "label": "7日", "value": "close_7_avg" ,"cvalue":"close_7_avg_c"},
  { "label": "29日", "value": "close_29_avg" ,"cvalue":"close_29_avg_c"},
  { "label": "89日", "value": "close_89_avg" ,"cvalue":"close_89_avg_c"},
  { "label": "344日", "value": "close_344_avg","cvalue":"close_344_avg_c" }
]
const scolumns = ref([])
// function onModelChanged() {
//   columns.value = []
//   cmodels.value.forEach((cmodel, index) => {

//     columns.value.push({ "label": cmodel.label, "prop": "close_" + cmodel.value })
//   })

// }

function onCaculate() {
  tableData.value = []
  let models = []
  // cmodels.value.forEach((cmodel, index) => {
  //   models.push(cmodel.value)
  // })
  codes.value.forEach((item, index) => {

    getStockCorr(item.value, cmodel.value).then((response) => {

      var row = JSON.parse(response.data)
      row.scode = item.value
      row.sname = item.label
      var total=0;
      scolumns.value.forEach((ele,idx)=>{
        total+=row[ele["cvalue"]]
      })
      row.total=total.toFixed(2)
      tableData.value.push(row)



    })

    // getStockCorrelations(item.value,models.toString()).then((response)=>{
    //       var row = JSON.parse(response.data)
    //       row.scode = item.value
    //       row.sname = item.label
    //       tableData.value.push(row)
    // })
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
      options.value.push({ "value": item.ts_code, "label": item.name+"_"+item.ts_code })
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