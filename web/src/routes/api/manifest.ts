import { manifestFileBuf } from "@/api";
import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/api/manifest")({
  server: {
    handlers: {
      GET: () =>
        new Response(manifestFileBuf, {
          headers: { "Content-Type": "application/json" },
        }),
    },
  },
});
