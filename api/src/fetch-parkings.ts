import type { GeoJSON } from "geojson";
import ky from "ky";
import assert from "node:assert/strict";
import * as z from "zod/mini";

const DATASET_URL =
  "https://opendata.vlci.valencia.es/api/3/action/package_show?id=ba531c74-8f0b-4da9-98da-4d6d3b74a351";

const GEOJSON_URL =
  "https://geoportal.valencia.es/server/rest/services/OPENDATA/Trafico/MapServer/206/query?where=1%3D1&outFields=*&f=geojson";

export const getModifiedDateString = async () =>
  (
    await ky(DATASET_URL).json(
      z.object({ result: z.object({ last_updated: z.coerce.date() }) }),
    )
  ).result.last_updated;

const assertType: <Value extends { type: string }, Type extends Value["type"]>(
  value: Value,
  type: Type,
) => asserts value is Value & { type: Type } = (value, type) =>
  assert.equal(value.type.toLowerCase(), type.toLowerCase());

export const fetchParkings = async () => {
  const updatedAt = (await getModifiedDateString()) || new Date(0);

  // We don't use Zod here because it would have a significant performance
  // impact by iterating over the whole dataset.
  const data = await ky(GEOJSON_URL).json<GeoJSON>();
  assertType(data, "FeatureCollection");

  if (data.features.length === 0) {
    throw new Error("No parking data found");
  }

  const spots = data.features.map((feat) => {
    assertType(feat, "Feature");
    assertType(feat.geometry, "Point");

    const { numplazas, tipo } = feat.properties as {
      numplazas?: number;
      tipo?: string;
    };
    const [longitude, latitude] = feat.geometry.coordinates;

    const type = tipo && tipo !== " " ? tipo : null;

    return {
      id: `${latitude}:${longitude}`,
      coordinate: { latitude, longitude },
      capacity: numplazas,
      type,
    };
  });

  return { updatedAt, spots };
};
