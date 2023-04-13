<script setup>
import { onBeforeRouteLeave, onBeforeRouteUpdate } from 'vue-router'
import { RouterView, useRouter } from "vue-router";
import { onMounted, watch } from "vue";
const router = useRouter()

onMounted(() => {
  const importTE = async () => {
    await import("tw-elements");

  };
  importTE();
});


</script>

<template>

    <router-view  />

</template>

