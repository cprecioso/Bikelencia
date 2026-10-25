import { tanstackStart } from "@tanstack/react-start/plugin/vite";
import { vanillaExtractPlugin } from "@vanilla-extract/vite-plugin";
import viteReact from "@vitejs/plugin-react";
import { nitro } from "nitro/vite";
import { defineConfig } from "vite";
import { LOCALES } from "./src/locales/locales.ts";

// `vite build --mode static` emits a fully static site: no server, and `/`
// redirects to a locale on the client instead.
export default defineConfig(({ command, mode }) => ({
  server: {
    port: 3000,
  },
  resolve: {
    tsconfigPaths: true,
  },
  plugins: [
    tanstackStart({
      prerender: {
        enabled: true,
        // With a server, `/` negotiates the locale per request.
        filter: ({ path }) => mode === "static" || path !== "/",
      },
      // `/$locale` is dynamic, so seed each locale; `crawlLinks` finds the rest.
      pages: LOCALES.map((locale) => ({ path: `/${locale}` })),
    }),
    nitro(mode === "static" ? { preset: "static" } : {}),
    // react's vite plugin must come after start's vite plugin
    viteReact(),
    // Defaults to Vite's mode, which would give debug class names in static builds.
    vanillaExtractPlugin({
      identifiers: command === "build" ? "short" : "debug",
    }),
  ],
}));
