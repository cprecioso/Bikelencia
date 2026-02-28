import { isLocale, LOCALES, i18n as makeI18n } from "@/locales";
import { Metadata } from "next";
import { notFound } from "next/navigation";
import { ReactNode } from "react";
import { NavMenu } from "./nav-menu";
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

  const { t } = makeI18n(locale);
  return { title: t("app-name") };
};

export default async function RootLayout({
  children,
  params,
}: {
  children: ReactNode;
  params: Promise<Params>;
}) {
  const { locale } = await params;
  if (!isLocale(locale)) notFound();

  const i18n = makeI18n(locale);

  return (
    <html lang={locale}>
      <body className={styles.body}>
        <main>{children}</main>
        <nav className={styles.nav}>
          <NavMenu i18n={i18n} />
        </nav>
      </body>
    </html>
  );
}

export const generateStaticParams = async (): Promise<Params[]> =>
  LOCALES.map((locale) => ({ locale }));
