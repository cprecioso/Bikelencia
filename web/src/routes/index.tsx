import { LOCALES } from "@/locales";
import { negotiateLocale } from "@/locales/negotiate";
import * as styles from "@/styles.css";
import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useEffect } from "react";

export const Route = createFileRoute("/")({
  server: {
    handlers: {
      GET: ({ request, next }) => {
        // Static builds prerender this route, so render the client redirect.
        if (import.meta.env.MODE === "static") return next();

        const locale = negotiateLocale(request.headers.get("accept-language"));
        return Response.redirect(new URL("/" + locale, request.url), 307);
      },
    },
  },
  head: () => ({
    links: LOCALES.map((locale) => ({
      rel: "alternate",
      hrefLang: locale,
      href: `/${locale}`,
    })),
  }),
  component: LocaleRedirect,
});

function LocaleRedirect() {
  const navigate = useNavigate();

  useEffect(() => {
    const locale = negotiateLocale(navigator.languages.join(","));
    void navigate({ to: "/$locale", params: { locale }, replace: true });
  }, [navigate]);

  // Shown until the redirect runs, or instead of it without JavaScript.
  return (
    <nav className={styles.nav}>
      {LOCALES.map((locale) => (
        <p key={locale}>
          <Link to="/$locale" params={{ locale }}>
            {locale.toUpperCase()}
          </Link>
        </p>
      ))}
    </nav>
  );
}
