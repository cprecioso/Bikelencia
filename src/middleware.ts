import { DEFAULT_LOCALE, LOCALES } from "@/locales";
import Negotiator from "negotiator";
import { NextRequest, NextResponse } from "next/server";

export function middleware(request: NextRequest) {
  const headers = Object.fromEntries(request.headers);
  const negotiator = new Negotiator({ headers });
  const locale = negotiator.language(LOCALES) ?? DEFAULT_LOCALE;
  return NextResponse.redirect(new URL("/" + locale, request.url));
}

export const config = {
  matcher: "/",
};
