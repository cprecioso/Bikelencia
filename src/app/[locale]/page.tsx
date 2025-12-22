import { Locale, i18n, isLocale } from "@/locales";
import { Metadata } from "next";
import Image from "next/image";
import { notFound } from "next/navigation";
import icon from "../icon.png";
import type { Params as ParentParams } from "./layout";
import downloadImageEn from "./media/download_en.svg";
import downloadImageEs from "./media/download_es.svg";
import * as styles from "./styles.css";

const getAppStoreImage = (locale: Locale) => {
  if (locale === Locale.Spanish) return downloadImageEs;
  return downloadImageEn;
};

export type Params = {
  locale: Locale;
};

export const metadata: Metadata = {
  itunes: {
    appId: "6450419237",
  },
};

export default async function IndexPage({
  params,
}: {
  params: Promise<Params>;
}) {
  const { locale } = await params;
  const { t } = i18n(locale);

  return (
    <div className={styles.container}>
        <Image
          className={styles.icon}
        width={300}
        height={300}
          src={icon}
          alt={t("icon-alt")}
          priority
          quality={100}
        />

      <div className={styles.headingContainer}>
        <h1>{t("app-name")}</h1>
        <p>{t("app-shortdesc")}</p>
      </div>

      <a href={t("download-link")}>
        <Image
          src={getAppStoreImage(locale)}
          alt={t("download-alt")}
          priority
          quality={100}
        />
      </a>
    </div>
  );
}

export const generateStaticParams = async ({
  params: { locale },
}: {
  params: ParentParams;
}): Promise<Params[]> => (isLocale(locale) ? [{ locale }] : notFound());
