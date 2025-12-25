import * as L from "leaflet";
import markerIcon from "leaflet/dist/images/marker-icon.png";
import markerIcon2x from "leaflet/dist/images/marker-icon-2x.png";
import markerShadow from "leaflet/dist/images/marker-shadow.png";

// Fix default marker icon paths for bundled assets
L.Icon.Default.mergeOptions({
  iconRetinaUrl: markerIcon2x,
  iconUrl: markerIcon,
  shadowUrl: markerShadow,
});

export function initCafeMap() {
  const mapElement = document.getElementById("cafe-map");

  if (!mapElement) {
    return;
  }

  // Set up map
  const lat = parseFloat(mapElement.dataset.lat || "0");
  const lng = parseFloat(mapElement.dataset.lng || "0");
  const name = mapElement.dataset.name || "Cafe";
  const map = L.map("cafe-map", {
    attributionControl: false,
  }).setView([lat, lng], 15);

  // Use OpenStreetMap tiles
  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution:
      '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
  }).addTo(map);

  // Show marker with cafe details in popup
  const popupContent = `<div>
    <h3>${name}</h3>
    <p>Latitude: ${lat}</p>
    <p>Longitude: ${lng}</p>
  </div>`;
  L.marker([lat, lng]).addTo(map).bindPopup(popupContent);
}
