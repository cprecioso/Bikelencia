import { bikeParkingsFileBuf } from "@/api";
import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/api/bike-parkings")({
  server: {
    handlers: {
      GET: () =>
        new Response(bikeParkingsFileBuf, {
          headers: { "Content-Type": "application/json" },
        }),
    },
  },
});
