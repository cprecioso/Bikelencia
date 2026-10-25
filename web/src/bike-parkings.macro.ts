import data from "@bikelencia/data/data";

// Imported as a macro, so it runs at build time and the data is inlined. It is
// read from git, and a deployed server has neither the repo nor git.
export const bikeParkings = () => ({
  ...data,
  updatedAt: data.updatedAt.toISOString(),
});
