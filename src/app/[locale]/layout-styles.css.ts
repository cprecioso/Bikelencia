import { globalStyle, style } from "@vanilla-extract/css";

globalStyle("*", {
  boxSizing: "border-box",
});

export const html = style({});

export const body = style({
  margin: 0,
  fontFamily: "system-ui, sans-serif",
  textAlign: "center",
});

export const nav = style({
  textAlign: "center",
  marginTop: "2em",
});
