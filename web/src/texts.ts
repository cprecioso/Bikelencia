export const enum Text {
  Privacy = "privacy-policy",
  Support = "support",
}

export const TEXTS: Text[] = [Text.Privacy, Text.Support];

export const isText = (value: string): value is Text =>
  TEXTS.includes(value as Text);
