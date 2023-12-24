import { LOCALES, Locale, i18n } from "@/locales";
import { parse as parseMarkdown } from "marked";

export const enum Text {
  Privacy = "privacy-policy",
  Support = "support",
}

export type Params = { locale: Locale; text: Text };

export default async function TextPage({
  params: { locale, text },
}: {
  params: Params;
}) {
  const { t } = i18n(locale);

  return (
    <div>
      <h1>{t(`${text}-link`)}</h1>
      <div dangerouslySetInnerHTML={{ __html: parseMarkdown(t(text)) }} />
    </div>
  );
}

export const generateStaticParams = async (): Promise<Params[]> =>
  LOCALES.flatMap((locale) =>
    [Text.Privacy, Text.Support].map((text) => ({ locale, text })),
  );
