import { Locale, i18n, isLocale } from "@/locales";
import { parse as parseMarkdown } from "marked";
import { notFound } from "next/navigation";
import type { Params as ParentParams } from "../layout";

const enum Text {
  Privacy = "privacy-policy",
  Support = "support",
}

export type Params = { locale: Locale; text: Text };

export default async function TextPage({
  params,
}: {
  params: Promise<Params>;
}) {
  const { locale, text } = await params;
  const { t } = i18n(locale);

  return (
    <div>
      <h1>{t(`${text}-link`)}</h1>
      <div dangerouslySetInnerHTML={{ __html: parseMarkdown(t(text)) }} />
    </div>
  );
}

export const generateStaticParams = async ({
  params: { locale },
}: {
  params: ParentParams;
}): Promise<Params[]> =>
  isLocale(locale)
    ? [Text.Privacy, Text.Support].map((text) => ({ locale, text }))
    : notFound();
