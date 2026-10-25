import Negotiator from "negotiator";
import { DEFAULT_LOCALE, LOCALES, Locale } from "./locales";

export const negotiateLocale = (acceptLanguage: string | null): Locale => {
  const negotiator = new Negotiator({
    headers: { "accept-language": acceptLanguage ?? undefined },
  });
  return (negotiator.language(LOCALES) as Locale | undefined) ?? DEFAULT_LOCALE;
};
