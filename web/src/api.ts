import { bikeParkings } from "./bike-parkings.macro.ts" with { type: "macro" };

const bikeParkingsData = bikeParkings();

const encoder = new TextEncoder();

export const bikeParkingsFile = encoder.encode(
  JSON.stringify(bikeParkingsData, null, 2),
);

export const manifestFile = encoder.encode(
  JSON.stringify(
    {
      bikeParkings: {
        updatedAt: bikeParkingsData.updatedAt,
        size: bikeParkingsFile.length,
      },
    },
    null,
    2,
  ),
);

export const jsonResponse = (file: Uint8Array<ArrayBuffer>) =>
  new Response(file, { headers: { "Content-Type": "application/json" } });
