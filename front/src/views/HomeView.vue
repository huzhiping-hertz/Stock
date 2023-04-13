<template>
    <LayoutMain>

        <SectionMain>

            <CardBox class="mb-6">

                <el-form :inline="true" :model="formInline" class="demo-form-inline">
                    <el-form-item label="开始时间">
                        <el-date-picker v-model="dateStart" type="date" placeholder="Pick a day" size="large" />
                    </el-form-item>
                    <el-form-item label="结束时间">
                        <el-date-picker v-model="dataStop" type="date" placeholder="Pick a day" size="large" />
                    </el-form-item>
                    <el-form-item label="代码">
                        <el-select v-model="value1" multiple placeholder="Select" size="large">
                            <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value" />
                        </el-select>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="onSubmit" size="large">数据分析</el-button>
                    </el-form-item>
                </el-form>

            </CardBox>

        </SectionMain>

        <SectionMain>


            <CardBox class="mb-6">
                <CandalStick />
            </CardBox>


        </SectionMain>

    </LayoutMain>
</template>
<script setup>
import { reactive } from 'vue'
import LayoutMain from "@/layouts/LayoutMain.vue";
import SectionMain from "@/components/SectionMain.vue";
import CardBox from "@/components/CardBox.vue";
import CandalStick from "@/components/Stocks/CandalStick.vue";

import { ref } from 'vue'

const dateStart = ref('')
const dataStop = ref('')

const formInline = reactive({
    user: '',
    region: '',
})

const onSubmit = () => {
    console.log('submit!')
}

</script>