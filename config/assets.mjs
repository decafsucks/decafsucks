import * as assets from "hanami-assets";
import postcss from "esbuild-postcss";

await assets.run({
  esbuildOptionsFn: (args, esbuildOptions) => {
    const plugins = [...esbuildOptions.plugins, postcss()];

    return {
      ...esbuildOptions,
      plugins,
    };
  },
});
