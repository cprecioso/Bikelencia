import { tanstackStart } from "@tanstack/react-start/plugin/vite";
import { vanillaExtractPlugin } from "@vanilla-extract/vite-plugin";
import viteReact from "@vitejs/plugin-react";
import { nitro } from "nitro/vite";
import Macros from "unplugin-macros/vite";
import { defineConfig } from "vite";
import { LOCALES } from "./src/locales/locales.ts";

// Not linked from any page, so crawling won't find them. Prerendering writes
// them as extensionless files, which static hosts can serve as is.
const API_ROUTES = ["/api/bike-parkings", "/api/manifest"];

// `vite build --mode static` emits a fully static site: no server, and `/`
// redirects to a locale on the client instead. Nitro's static preset
// prerenders it all by crawling from `/`; Start's prerender would only see that
// static output, so it is off.
export default defineConfig(({ command, mode }) => ({
  server: {
    port: 3000,
  },
  resolve: {
    tsconfigPaths: true,
  },
  plugins: [
    Macros(),
    tanstackStart({
      prerender: {
        enabled: mode !== "static",
        // With a server, `/` negotiates the locale per request.
        filter: ({ path }) => path !== "/",
      },
      // `/$locale` is dynamic, so seed each locale; `crawlLinks` finds the rest.
      pages: [...LOCALES.map((locale) => `/${locale}`), ...API_ROUTES].map(
        (path) => ({ path }),
      ),
    }),
    nitro(
      mode === "static"
        ? { preset: "static", prerender: { routes: ["/", ...API_ROUTES] } }
        : {},
    ),
    // react's vite plugin must come after start's vite plugin
    viteReact(),
    // Defaults to Vite's mode, which would give debug class names in static builds.
    vanillaExtractPlugin({
      identifiers: command === "build" ? "short" : "debug",
    }),
  ],
}));
