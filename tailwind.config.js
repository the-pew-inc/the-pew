/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: "class",
  content: [
    "./app/views/**/*.html.erb",
    "./app/components/**/*.rb",
    "./app/components/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/presenters/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
    "./node_modules/flowbite/**/*.js",
  ],
  theme: {
    extend: {},
  },
  plugins: [require("@tailwindcss/line-clamp"), require("flowbite/plugin")],
};
