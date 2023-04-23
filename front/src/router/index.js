import { createRouter, createWebHashHistory } from "vue-router";
import HomeView from "@/views/HomeView.vue";
import DataView from "@/views/DataView.vue";
import ModelView from "@/views/ModelView.vue";
import ModelCreateView from "@/views/ModelCreateView.vue";
import ResultView from "@/views/ResultView.vue";

const routes = [
  {
    meta: {
      title: "Home",
    },
    path: "/",
    name: "Home",
    component: HomeView,
  },
  {
    meta: {
      title: "DataManage",
    },
    path: "/data",
    name: "Data",
    component: DataView,
  },
  {
    meta: {
      title: "ModelManage",
    },
    path: "/model",
    name: "Model",
    component: ModelView,
  },
  {
    meta: {
      title: "ModelCreate",
    },
    path: "/model/create",
    name: "ModelCreate",
    component: ModelCreateView,
  },
  {
    meta: {
      title: "ComputeData",
    },
    path: "/process",
    name: "DBProcess",
    component: ResultView,
  }
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,

});

export default router;
