import { i18n } from "@/locales";
import { isText } from "@/texts";
import { createFileRoute } from "@tanstack/react-router";
import { parse as parseMarkdown } from "marked";

export const Route = createFileRoute("/$locale/$text")({
  params: {
    parse: ({ text }) => isText(text) && { text },
  },
  component: TextPage,
});

function TextPage() {
  const { locale, text } = Route.useParams();
  const { t } = i18n(locale);

  return (
    <div>
      <h1>{t(`${text}-link`)}</h1>
      <div
        dangerouslySetInnerHTML={{
          __html: parseMarkdown(t(text), { async: false }),
        }}
      />
    </div>
  );
}
