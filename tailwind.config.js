/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/components/**/*.rb",
    "./app/components/**/*html.erb",
    "./app/helpers/**/*.rb",
    "./app/presenters/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
  ],
  theme: {
    extend: {},
  },
  plugins: [require("@tailwindcss/line-clamp"), require("@tailwindcss/forms")],
};
