<template>
  <div class="p-5 mt-32 bg-slate-900/70">

    <el-menu active-text-color="#ffd04b" background-color="rgb(15,23,42/0.7)" default-active="1"  text-color="#fff" @open="handleOpen" @close="handleClose" router="true">

      <el-menu-item index="/">
        <el-icon><icon-menu /></el-icon>
        <span>数据分析</span>
      </el-menu-item>
      <el-menu-item index="/model">
        <el-icon>
          <document />
        </el-icon>
        <span>数据模型</span>
      </el-menu-item>
      <el-menu-item index="/data">
        <el-icon>
          <setting />
        </el-icon>
        <span>数据同步</span>
      </el-menu-item>
      <el-menu-item index="/process">
        <el-icon>
          <setting />
        </el-icon>
        <span>批量计算</span>
      </el-menu-item>
    </el-menu>
  </div>
</template>
  
<script setup>
import {
  Document,
  Menu as IconMenu,
  Location,
  Setting,
} from '@element-plus/icons-vue'

</script>
  