import { LOCALES, i18n, isLocale } from "@/locales";
import { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { Children, Fragment, ReactNode } from "react";
import * as styles from "./styles.css";

export type Params = {
  locale: string;
};

export const generateMetadata = async ({
  params,
}: {
  params: Promise<Params>;
}): Promise<Metadata> => {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();

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

export default async function RootLayout({
  children,
  params,
}: {
  children: ReactNode;
  params: Promise<Params>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();

  const { t } = i18n(locale);

  return (
    <html lang={locale}>
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
