import bikeParkingsData from "@bikelencia/data/data";
import assert from "node:assert/strict";
import * as fs from "node:fs/promises";
import * as path from "node:path";

const bikeParkingsFile = new TextEncoder().encode(
  JSON.stringify(bikeParkingsData, null, 2),
);

const manifestData = {
  bikeParkings: {
    updatedAt: bikeParkingsData.updatedAt.toISOString(),
    size: bikeParkingsFile.length,
  },
};
const manifestFile = new TextEncoder().encode(
  JSON.stringify(manifestData, null, 2),
);

const dest = process.argv[2];
assert(dest, "Destination directory must be provided as the first argument");

await fs.mkdir(dest, { recursive: true });
await fs.writeFile(path.join(dest, "bike-parkings.json"), bikeParkingsFile);
await fs.writeFile(path.join(dest, "manifest.json"), manifestFile);
