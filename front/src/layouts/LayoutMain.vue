<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import menuAside from "@/menuAside.js";
import { useStyleStore } from "@/stores/style.js";
import AsideMenu from "@/components/AsideMenu.vue";
import SideMenu from "@/components/SideMenu.vue";

const layoutAsidePadding = "xl:pl-60";

const styleStore = useStyleStore();

const router = useRouter();

const isAsideMobileExpanded = ref(false);
const isAsideLgActive = ref(false);

router.beforeEach(() => {
  isAsideMobileExpanded.value = false;
  isAsideLgActive.value = false;
});

const menuClick = (event, item) => {

  //location.reload();
};


</script>

<!-- <template>
  <div
    :class="{
      dark: styleStore.darkMode,
      'overflow-hidden lg:overflow-visible': isAsideMobileExpanded,
    }"
  >
    <div
      :class="[layoutAsidePadding, { 'ml-60 lg:ml-0': isAsideMobileExpanded }]"
      class=" min-h-screen w-screen transition-position lg:w-auto bg-gray-50 dark:bg-slate-800 dark:text-slate-100"
    >
      <AsideMenu
        :is-aside-mobile-expanded="isAsideMobileExpanded"
        :is-aside-lg-active="isAsideLgActive"
        :menu="menuAside"
        @menu-click="menuClick"
        @aside-lg-close-click="isAsideLgActive = false"
      />
      
      
    </div>
  </div>
</template> -->


<template>
  <div class="common-layout">
    <el-container>

      <el-header>
        <el-menu mode="horizontal" :default-active="activeIndex"  text-color="#fff" active-text-color="#ffd04b" router="true">

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
      </el-header>


      <el-main>
        <slot />
      </el-main>
  </el-container>
</div></template>
