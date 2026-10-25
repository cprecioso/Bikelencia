import icon from "@/icon.png";
import { Locale, LOCALES, i18n } from "@/locales";
import downloadImageEn from "@/media/download_en.svg";
import downloadImageEs from "@/media/download_es.svg";
import * as styles from "@/styles.css";
import { createFileRoute } from "@tanstack/react-router";

const getAppStoreImage = (locale: Locale) => {
  if (locale === Locale.Spanish) return downloadImageEs;
  return downloadImageEn;
};

export const Route = createFileRoute("/$locale/")({
  head: ({ params: { locale: currentLocale } }) => ({
    meta: [{ name: "apple-itunes-app", content: "app-id=6450419237" }],
    links: LOCALES.filter((locale) => locale !== currentLocale).map(
      (locale) => ({ rel: "alternate", hrefLang: locale, href: `/${locale}` }),
    ),
  }),
  component: IndexPage,
});

function IndexPage() {
  const { locale } = Route.useParams();
  const { t } = i18n(locale);

  return (
    <div className={styles.container}>
      <img
        className={styles.icon}
        width={300}
        height={300}
        src={icon}
        alt={t("icon-alt")}
        fetchPriority="high"
      />

      <div className={styles.headingContainer}>
        <h1>{t("app-name")}</h1>
        <p>{t("app-shortdesc")}</p>
      </div>

      <a href={t("download-link")}>
        <img
          src={getAppStoreImage(locale)}
          alt={t("download-alt")}
          fetchPriority="high"
        />
      </a>
    </div>
  );
}
