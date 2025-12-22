import { I18n, Key, Locale, LOCALES } from "@/locales";
import { Route } from "next";
import Link from "next/link";
import { Children } from "react";

const makeRoute = <T extends string>(path: Route<T>): Route => path as Route;

const MENU_ITEMS: {
  makeHref: (options: { locale: Locale }) => Route;
  label: Key;
}[] = [
  {
    makeHref: ({ locale }) => makeRoute(`/${locale}`),
    label: "home-link",
  },
  {
    makeHref: ({ locale }) => makeRoute(`/${locale}/privacy-policy`),
    label: "privacy-policy-link",
  },
  {
    makeHref: ({ locale }) => makeRoute(`/${locale}/support`),
    label: "support-link",
  },
];

export function NavMenu({ i18n }: { i18n: I18n }) {
  const currentLocale = i18n.locale;
  return (
    <>
      <p>
        <Sep sep=" | ">
          {MENU_ITEMS.map(({ makeHref, ...rest }) => ({
            ...rest,
            href: makeHref({ locale: currentLocale }),
          })).map(({ href, label }) => (
            <Link key={href} href={href}>
              {i18n.t(label)}
            </Link>
          ))}
        </Sep>
      </p>
      <p>
        <Sep sep=" | ">
          {LOCALES.filter((locale) => locale !== currentLocale).map(
            (locale) => (
              <Link key={locale} href={makeRoute(`/${locale}`)}>
                {locale.toUpperCase()}
              </Link>
            ),
          )}
        </Sep>
      </p>
    </>
  );
}

function Sep({ children, sep }: { children: React.ReactNode; sep: string }) {
  return Children.map(children, (child, index) => (
    <>
      {index === 0 ? null : sep}
      {child}
    </>
  ));
}
