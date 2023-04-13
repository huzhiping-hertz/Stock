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
      <el-aside width="250px"><SideMenu></SideMenu></el-aside>
      <el-main><slot /></el-main>
    </el-container>
  </div>
</template>
