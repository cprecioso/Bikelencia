import data from "@bikelencia/data/data";

const encoder = new TextEncoder();

export const bikeParkingsFileBuf = encoder.encode(JSON.stringify(data));

export const manifestFileBuf = encoder.encode(
  JSON.stringify({
    bikeParkings: {
      updatedAt: data.updatedAt,
      size: bikeParkingsFileBuf.byteLength,
    },
  }),
);
