import { LOCALES, Locale, i18n } from "@/locales";
import { Metadata } from "next";
import Link from "next/link";
import { Children, Fragment } from "react";
import * as styles from "./layout-styles.css";

type Params = {
  locale: Locale;
};

export const generateMetadata = ({
  params: { locale },
}: {
  params: Params;
}): Metadata => {
  const { t } = i18n(locale);
  return { title: t("app-name") };
};

const WithSeparator = ({ children }: { children: React.ReactNode }) => (
  <>
    {Children.map(children, (child, i) => (
      <Fragment>
        {i === 0 ? null : " | "}
        {child}
      </Fragment>
    ))}
  </>
);

export default function RootLayout({
  children,
  params: { locale },
}: {
  children: React.ReactNode;
  params: Params;
}) {
  const { t } = i18n(locale);

  return (
    <html lang={locale} className={styles.html}>
      <body className={styles.body}>
        <main>{children}</main>
        <nav className={styles.nav}>
          <WithSeparator>
            <Link href={`/${locale}`}>{t("home-link")}</Link>
            <Link href={`/${locale}/privacy-policy`}>
              {t("privacy-policy-link")}
            </Link>
            <Link href={`/${locale}/support`}>{t("support-link")}</Link>
          </WithSeparator>
        </nav>
      </body>
    </html>
  );
}

export const generateStaticParams = async (): Promise<Params[]> =>
  LOCALES.map((locale) => ({ locale }));
