import { DEFAULT_LOCALE } from "@/locales";
import { NextRequest, NextResponse } from "next/server";

export function middleware(request: NextRequest) {
  return NextResponse.redirect(new URL("/" + DEFAULT_LOCALE, request.url));
}

export const config = {
  matcher: "/",
};
