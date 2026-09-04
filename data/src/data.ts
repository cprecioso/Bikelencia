import data from "#/data.json" with { type: "json" };
import { $ } from "execa";
import { fileURLToPath } from "node:url";
import * as z from "zod";
import type { fullOutputSchema } from "./schema.ts";

const outputFilePath = fileURLToPath(import.meta.resolve("#/data.json"));

const { stdout } =
  await $`git --no-pager log -1 --pretty=%cd --date=iso-strict ${outputFilePath}`;
const updatedAt = new Date(stdout);

const fullData: z.output<typeof fullOutputSchema> = { ...data, updatedAt };

export default fullData;
