/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./public/*.html",
    "./app/assets/**/*",
    "./app/views/**/*.rb",
    "./app/templates/**/*",
    "./slices/**/assets/**/*",
    "./slices/**/views/**/*.rb",
    "./slices/**/templates/**/*",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}

