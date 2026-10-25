import { $ } from "execa";
import * as z from "zod";
import data from "../out/data.json" with { type: "json" };
import type { fullOutputSchema } from "./schema.ts";

// Kept independent of this file's location, so it still works once bundled:
// the JSON is imported, and `:/` makes git resolve the path from the repo root.
const { stdout } =
  await $`git --no-pager log -1 --pretty=%cd --date=iso-strict -- :/data/out/data.json`;
const updatedAt = new Date(stdout);

const fullData: z.output<typeof fullOutputSchema> = { ...data, updatedAt };

export default fullData;
