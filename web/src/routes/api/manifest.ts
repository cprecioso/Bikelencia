import { manifestFileSource } from "@/api";
import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/api/manifest")({
  server: {
    handlers: {
      GET: () =>
        new Response(manifestFileSource, {
          headers: { "Content-Type": "application/json" },
        }),
    },
  },
});
