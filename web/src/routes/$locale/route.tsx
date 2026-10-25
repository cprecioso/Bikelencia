import { i18n, isLocale } from "@/locales";
import { NavMenu } from "@/nav-menu";
import * as styles from "@/styles.css";
import { createFileRoute, Outlet } from "@tanstack/react-router";

export const Route = createFileRoute("/$locale")({
  params: {
    parse: ({ locale }) => isLocale(locale) && { locale },
  },
  head: ({ params: { locale } }) => ({
    meta: [{ title: i18n(locale).t("app-name") }],
  }),
  component: LocaleLayout,
});

function LocaleLayout() {
  const { locale } = Route.useParams();

  return (
    <>
      <main>
        <Outlet />
      </main>
      <nav className={styles.nav}>
        <NavMenu i18n={i18n(locale)} />
      </nav>
    </>
  );
}
