import ky from "ky";
import * as fs from "node:fs/promises";
import * as path from "node:path";
import { OUTPUT_FILE_PATH } from "./common.ts";
import { transformSchema } from "./schema.ts";

const GEOJSON_URL =
  "https://geoportal.valencia.es/server/rest/services/OPENDATA/Trafico/MapServer/206/query?where=1%3D1&outFields=*&f=geojson";

const data = await ky(GEOJSON_URL).json(transformSchema);

await fs.mkdir(path.dirname(OUTPUT_FILE_PATH), { recursive: true });
await fs.writeFile(OUTPUT_FILE_PATH, JSON.stringify(data, null, 2), "utf-8");
