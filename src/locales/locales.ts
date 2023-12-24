export const enum Locale {
  English = "en",
  Spanish = "es",
  Catalan = "ca",
}

export const LOCALES: Locale[] = [
  Locale.English,
  Locale.Spanish,
  Locale.Catalan,
];

export const DEFAULT_LOCALE = Locale.English;
DEFAULT_LOCALE satisfies Locale;
