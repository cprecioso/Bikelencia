import { LOCALES, Locale, i18n } from "@/locales";
import { Metadata } from "next";
import Image from "next/image";
import icon from "../icon.png";
import downloadImageEn from "./media/download_en.svg";
import downloadImageEs from "./media/download_es.svg";
import * as styles from "./styles.css";

const getAppStoreImage = (locale: Locale) => {
  if (locale === Locale.Spanish) return downloadImageEs;
  return downloadImageEn;
};

type Params = {
  locale: Locale;
};

export const metadata: Metadata = {
  itunes: {
    appId: "6450419237",
  },
};

export default async function IndexPage({
  params: { locale },
}: {
  params: Params;
}) {
  const { t } = i18n(locale);

  return (
    <div className={styles.container}>
      <div className={styles.iconContainer}>
        <Image
          className={styles.icon}
          fill
          src={icon}
          alt={t("icon-alt")}
          priority
          quality={100}
        />
      </div>

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

export const generateStaticParams = async (): Promise<Params[]> =>
  LOCALES.map((locale) => ({ locale }));
