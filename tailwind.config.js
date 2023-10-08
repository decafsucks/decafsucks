/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./public/*.html",
    "./app/views/**/*.rb",
    "./app/templates/**/*",
    "./slices/**/views/**/*.rb",
    "./slices/**/templates/**/*",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}

