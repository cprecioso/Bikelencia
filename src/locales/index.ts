import { DEFAULT_LOCALE, Locale } from "./locales";
import messagesCa from "./messages/ca.json";
import messagesEn from "./messages/en.json";
import messagesEs from "./messages/es.json";

const allMessages = {
  [Locale.English]: messagesEn,
  [Locale.Spanish]: messagesEs,
  [Locale.Catalan]: messagesCa,
} satisfies Record<Locale, Record<string, string> | undefined>;

const defaultMessages = allMessages[DEFAULT_LOCALE];

export type Key = keyof typeof defaultMessages;

export interface I18n {
  t(this: void, key: Key): string;
}

export const i18n = (locale: Locale): I18n => {
  const messages = allMessages[locale] ?? defaultMessages;

  return {
    t(key) {
      return key in messages ? messages[key] : key;
    },
  };
};

export * from "./locales";
