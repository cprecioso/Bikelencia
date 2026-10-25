import { I18n, Key, Locale, LOCALES } from "@/locales";
import { Text } from "@/texts";
import { Link, linkOptions } from "@tanstack/react-router";
import { Children, ReactNode } from "react";

const makeMenuItems = (locale: Locale) =>
  [
    {
      link: linkOptions({
        to: "/$locale",
        params: { locale },
        activeOptions: { exact: true },
      }),
      label: "home-link",
    },
    {
      link: linkOptions({
        to: "/$locale/$text",
        params: { locale, text: Text.Privacy },
      }),
      label: "privacy-policy-link",
    },
    {
      link: linkOptions({
        to: "/$locale/$text",
        params: { locale, text: Text.Support },
      }),
      label: "support-link",
    },
  ] satisfies { link: unknown; label: Key }[];

export function NavMenu({ i18n }: { i18n: I18n }) {
  const currentLocale = i18n.locale;
  return (
    <>
      <p>
        <Sep sep=" | ">
          {makeMenuItems(currentLocale).map(({ link, label }) => (
            <Link key={label} {...link}>
              {i18n.t(label)}
            </Link>
          ))}
        </Sep>
      </p>
      <p>
        <Sep sep=" | ">
          {LOCALES.filter((locale) => locale !== currentLocale).map(
            (locale) => (
              <Link key={locale} to="/$locale" params={{ locale }}>
                {locale.toUpperCase()}
              </Link>
            ),
          )}
        </Sep>
      </p>
    </>
  );
}

function Sep({ children, sep }: { children: ReactNode; sep: string }) {
  return Children.map(children, (child, index) => (
    <>
      {index === 0 ? null : sep}
      {child}
    </>
  ));
}
