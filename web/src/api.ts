import data from "@bikelencia/data/data";

export const bikeParkingsFileSource = JSON.stringify(data);

export const manifestFileSource = JSON.stringify({
  bikeParkings: {
    updatedAt: data.updatedAt,
    size: bikeParkingsFileSource.length,
  },
});
