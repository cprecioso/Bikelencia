import ky from "ky";
import * as fs from "node:fs/promises";
import * as path from "node:path";
import { parseArgs } from "node:util";
import { transformSchema } from "./schema.ts";

const [_outputFile] = parseArgs({ allowPositionals: true }).positionals;
const outputFile = path.resolve(_outputFile);

const GEOJSON_URL =
  "https://geoportal.valencia.es/server/rest/services/OPENDATA/Trafico/MapServer/206/query?where=1%3D1&outFields=*&f=geojson";

const data = await ky(GEOJSON_URL).json(transformSchema);

fs.mkdir(path.dirname(outputFile), { recursive: true });
fs.writeFile(outputFile, JSON.stringify(data, null, 2), "utf-8");
