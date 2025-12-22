import { globalStyle, style } from "@vanilla-extract/css";

globalStyle("*", {
  boxSizing: "border-box",
});

globalStyle(":root", {
  colorScheme: "light dark",
});

export const body = style({
  margin: "2em 0",
  fontFamily: "system-ui, sans-serif",
  textAlign: "center",
});

export const nav = style({
  textAlign: "center",
  marginTop: "2em",
});

export const container = style({
  display: "flex",
  flexFlow: "column nowrap",
  alignItems: "center",
  width: "80vw",
  maxWidth: "800px",
  margin: "0 auto",
  padding: "1em",
});

export const icon = style({
  objectFit: "contain",
  maxWidth: "300px",
});

export const headingContainer = style({});
