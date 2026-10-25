import { jsonResponse, manifestFile } from "@/api";
import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/api/manifest")({
  server: { handlers: { GET: () => jsonResponse(manifestFile) } },
});
