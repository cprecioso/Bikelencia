import { $ } from "execa";
import * as fs from "node:fs/promises";
import * as z from "zod";
import { OUTPUT_FILE_PATH } from "./common.ts";
import type { fullOutputSchema } from "./schema.ts";

const { stdout } =
  await $`git --no-pager log -1 --pretty=%cd --date=iso-strict ${OUTPUT_FILE_PATH}`;
const updatedAt = new Date(stdout);

const data = await fs
  .readFile(OUTPUT_FILE_PATH, "utf-8")
  .then((content) => JSON.parse(content) as typeof import("../out/data.json"));

const fullData: z.output<typeof fullOutputSchema> = { ...data, updatedAt };

export default fullData;
