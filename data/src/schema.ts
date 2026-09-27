import { unimplemented } from "@std/assert";
import type { GeoJSON } from "geojson";
import * as z from "zod";

export const inputSchema = z.object({
  type: z.literal("FeatureCollection"),
  features: z
    .object({
      type: z.literal("Feature"),
      geometry: z.object({
        type: z.literal("Point"),
        coordinates: z.tuple([z.number(), z.number()]),
      }),
      properties: z.object({
        numplazas: z.number().optional(),
        tipo: z.string().optional(),
      }),
    })
    .array()
    .nonempty(),
}) satisfies z.ZodType<unknown, GeoJSON>;

export const outputSchema = z.object({
  spots: z
    .object({
      id: z.string(),
      coordinate: z.object({
        latitude: z.number(),
        longitude: z.number(),
      }),
      capacity: z.number().optional(),
      type: z.string().optional(),
    })
    .array(),
});

export const fullOutputSchema = outputSchema.extend({
  updatedAt: z.date(),
});

export const transformSchema = z.codec(inputSchema, outputSchema, {
  decode(data) {
    return {
      spots: data.features
        .map(
          ({
            geometry: {
              coordinates: [longitude, latitude],
            },
            properties: { numplazas: capacity, tipo: type },
          }) => ({
            id: `${longitude}:${latitude}`,
            coordinate: { longitude, latitude },
            capacity: capacity,
            type,
          }),
        )
        .toSorted((a, b) => a.id.localeCompare(b.id)),
    };
  },
  encode() {
    unimplemented();
  },
});
