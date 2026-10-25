import { tanstackStart } from "@tanstack/react-start/plugin/vite";
import { vanillaExtractPlugin } from "@vanilla-extract/vite-plugin";
import viteReact from "@vitejs/plugin-react";
import { defineConfig } from "vite";

export default defineConfig({
  resolve: {
    tsconfigPaths: true,
  },
  plugins: [
    tanstackStart({
      prerender: {
        enabled: true,
      },
      // Not linked from any page, so crawling won't find them.
      pages: [{ path: "/api/bike-parkings" }, { path: "/api/manifest" }],
    }),
    viteReact(),
    vanillaExtractPlugin(),
  ],
});
