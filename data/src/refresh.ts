import ky from "ky";
import * as fs from "node:fs/promises";
import * as path from "node:path";
import * as z from "zod";
import { OUTPUT_FILE_PATH } from "./common.ts";
import { transformSchema } from "./schema.ts";

const QUERY_URL =
  "https://geoportal.valencia.es/server/rest/services/OPENDATA/Trafico/MapServer/206/query";

// The server caps each response (currently at 2,000 records) and sets
// `exceededTransferLimit` when there are more, so we page with `resultOffset`.
const pageSchema = z.object({
  features: z.unknown().array(),
  exceededTransferLimit: z.boolean().optional(),
});

const features: unknown[] = [];
let exceededTransferLimit = true;
while (exceededTransferLimit) {
  const page = await ky(QUERY_URL, {
    searchParams: {
      where: "1=1",
      outFields: "*",
      orderByFields: "objectid",
      resultOffset: features.length,
      f: "geojson",
    },
  }).json(pageSchema);

  features.push(...page.features);
  exceededTransferLimit = page.exceededTransferLimit ?? false;
}

const data = transformSchema.parse({ type: "FeatureCollection", features });

await fs.mkdir(path.dirname(OUTPUT_FILE_PATH), { recursive: true });
await fs.writeFile(
  OUTPUT_FILE_PATH,
  `${JSON.stringify(data, null, 2)}\n`,
  "utf-8",
);
