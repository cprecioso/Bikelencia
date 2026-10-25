import { bikeParkingsFile, jsonResponse } from "@/api";
import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/api/bike-parkings")({
  server: { handlers: { GET: () => jsonResponse(bikeParkingsFile) } },
});
