<template>
  <LayoutMain>

    <SectionMain>


      <CardBox class="mb-6 ">
        <el-form :inline="true" :model="formInline" class="demo-form-inline">
          <el-form-item label="模型">
            <el-select v-model="value1" multiple placeholder="Select" size="large">
              <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="onSubmit" size="large">计算</el-button>
          </el-form-item>
        </el-form>

      </CardBox>

    </SectionMain>

    <SectionMain>


      <CardBox class="mb-6">
        <el-table :data="filterTableData" style="width: 100%">
          <el-table-column label="Date" prop="date" />
          <el-table-column label="Name" prop="name" />
          <el-table-column align="right">
            <template #header>
              <el-input v-model="search" size="small" placeholder="Type to search" />
            </template>
            <template #default="scope">
              <el-button size="small" @click="handleEdit(scope.$index, scope.row)">Edit</el-button>
              <el-button size="small" type="danger" @click="handleDelete(scope.$index, scope.row)">Delete</el-button>
            </template>
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

const search = ref('')
const filterTableData = computed(() =>
  tableData.filter(
    (data) =>
      !search.value ||
      data.name.toLowerCase().includes(search.value.toLowerCase())
  )
)

const tableData= [
  {
    date: '2016-05-03',
    name: 'Tom',
    address: 'No. 189, Grove St, Los Angeles',
  },
  {
    date: '2016-05-02',
    name: 'John',
    address: 'No. 189, Grove St, Los Angeles',
  },
  {
    date: '2016-05-04',
    name: 'Morgan',
    address: 'No. 189, Grove St, Los Angeles',
  },
  {
    date: '2016-05-01',
    name: 'Jessy',
    address: 'No. 189, Grove St, Los Angeles',
  },
]

</script>