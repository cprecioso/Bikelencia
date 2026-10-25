import { tanstackStart } from "@tanstack/react-start/plugin/vite";
import { vanillaExtractPlugin } from "@vanilla-extract/vite-plugin";
import viteReact from "@vitejs/plugin-react";
import { nitro } from "nitro/vite";
import { defineConfig, type Plugin } from "vite";
import { LOCALES } from "./src/locales/locales.ts";

// Exposes the bike parkings data as `virtual:bike-parkings`. It is read from
// git at build time, since a deployed server has neither the repo nor git.
const bikeParkings = (): Plugin => {
  const id = "virtual:bike-parkings";
  return {
    name: "bike-parkings",
    resolveId: (source) => (source === id ? "\0" + id : undefined),
    async load(source) {
      if (source !== "\0" + id) return null;
      const { default: data } = await import("@bikelencia/data/data");
      return `export default ${JSON.stringify(data)};`;
    },
  };
};

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
    bikeParkings(),
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
