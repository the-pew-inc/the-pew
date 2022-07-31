const path = require("path");
const { replace } = require("esbuild-plugin-replace");

const watch = process.argv.includes("--watch") && {
  onRebuild(error) {
    if (error) console.error("[watch] build failed", error);
    else console.log("[watch] build finished");
  },
};

require("esbuild")
  .build({
    entryPoints: ["application.js"],
    bundle: true,
    outdir: path.join(process.cwd(), "app/assets/builds"),
    absWorkingDir: path.join(process.cwd(), "app/javascript"),
    watch: watch,
    // custom plugins will be inserted is this array
    plugins: [
      replace({
        DOMContentLoaded: "turbo:load",
      }),
    ],
  })
  .catch((error) => {
    console.error("[esbuild] build failed", error);
    process.exit(1);
  });
