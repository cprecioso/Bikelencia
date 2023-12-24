import { style } from "@vanilla-extract/css";

export const container = style({
  display: "flex",
  flexFlow: "column nowrap",
  alignItems: "center",
  width: "80vw",
  maxWidth: "800px",
  margin: "0 auto",
  padding: "1em",
});

export const iconContainer = style({
  position: "relative",
  width: "100%",
  aspectRatio: "1",
  maxWidth: "300px",
});

export const icon = style({
  objectFit: "contain",
  borderRadius: "5%",
  border: "1px solid lightgray",
});

export const headingContainer = style({});
