import { tanstackStart } from "@tanstack/react-start/plugin/vite";
import { vanillaExtractPlugin } from "@vanilla-extract/vite-plugin";
import viteReact from "@vitejs/plugin-react";
import Macros from "unplugin-macros/vite";
import { defineConfig } from "vite";

export default defineConfig({
  resolve: {
    tsconfigPaths: true,
  },
  plugins: [
    Macros(),
    tanstackStart({
      prerender: {
        enabled: true,
      },
    }),
    viteReact(),
    vanillaExtractPlugin(),
  ],
});
