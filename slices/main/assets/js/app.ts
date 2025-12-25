import "@app/builds/tailwind.css";
import "@main/css/app.css";
import "leaflet/dist/leaflet.css";
import { initCafeMap } from "./cafe-map";

document.addEventListener("DOMContentLoaded", () => {
  initCafeMap();
});
