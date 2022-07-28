const path = require("path");
const { replace } = require("esbuild-plugin-replace");

require("esbuild")
  .build({
    entryPoints: ["application.js"],
    bundle: true,
    outdir: path.join(process.cwd(), "app/assets/builds"),
    absWorkingDir: path.join(process.cwd(), "app/javascript"),
    watch: process.argv.includes("--watch"),
    // custom plugins will be inserted is this array
    plugins: [
      replace({
        DOMContentLoaded: "turbo:load",
      }),
    ],
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
