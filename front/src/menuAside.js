import {
  mdiAccountCircle,
  mdiMonitor,
  mdiGithub,
  mdiLock,
  mdiAlertCircle,
  mdiSquareEditOutline,
  mdiTable,
  mdiViewList,
  mdiTelevisionGuide,
  mdiResponsive,
  mdiPalette,
  mdiReact,
} from "@mdi/js";

export default [
  {
    to: "/",
    icon: mdiMonitor,
    label: "Data Analysis",
  },
  {
    to: "/data",
    label: "Data Manage",
    icon: mdiTable,
  },
  {
    to: "/model",
    label: "Model Manage",
    icon: mdiResponsive,
  },
];
