import type { ViewFn } from "@icelab/defo";
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

type Props = {
  lat: number;
  lng: number;
  name: string;
  zoom?: number;
};

export const cafeMapViewFn: ViewFn<Props> = (
  node: HTMLElement,
  { lat, lng, name, zoom = 15 }: Props,
) => {
  // Initialize the map
  const map = L.map(node).setView([lat, lng], zoom);

  // Add OpenStreetMap tiles
  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution:
      '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
  }).addTo(map);

  // Create popup content with cafe details
  const popupContent = `<div>
    <h3>${name}</h3>
    <p>Latitude: ${lat}</p>
    <p>Longitude: ${lng}</p>
  </div>`;

  // Add marker with popup
  L.marker([lat, lng]).addTo(map).bindPopup(popupContent);

  return {
    destroy: () => {
      map.remove();
    },
  };
};
