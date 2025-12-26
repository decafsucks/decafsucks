import * as assets from "hanami-assets";

// Assets are managed by esbuild (https://esbuild.github.io), and can be
// customized below.
//
// Learn more at https://guides.hanamirb.org/assets/customization/.

await assets.run({
  esbuildOptionsFn: (args, esbuildOptions) => {
    // Customize your `esbuildOptions` here.
    //
    // Use the `args.watch` boolean as a condition to apply diffierent options
    // when running `hanami assets watch` vs `hanami assets compile`.

    // Set public path to ensure referenced file assets use absolute URLs,
    // detecting the slice name from the asset destination path.
    //
    // This is necessary for the Leaflet image paths to work. Later, we may
    // consider setting publicPath as part of standard hanami-assets behavior.
    const sliceName = args.dest.split("/").pop();
    esbuildOptions.publicPath = `/assets/${sliceName}`;

    return esbuildOptions;
  },
});
