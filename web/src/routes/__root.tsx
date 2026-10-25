import {
  createRootRoute,
  HeadContent,
  Outlet,
  Scripts,
  useParams,
} from "@tanstack/react-router";
import { ReactNode } from "react";
import icon from "../icon.png";
import * as styles from "../styles.css";

export const Route = createRootRoute({
  head: () => ({
    meta: [
      { charSet: "utf-8" },
      { name: "viewport", content: "width=device-width, initial-scale=1" },
    ],
    links: [{ rel: "icon", type: "image/png", href: icon }],
  }),
  component: RootComponent,
});

function RootComponent() {
  return (
    <RootDocument>
      <Outlet />
    </RootDocument>
  );
}

function RootDocument({ children }: { children: ReactNode }) {
  const { locale } = useParams({ strict: false });

  return (
    <html lang={locale}>
      <head>
        <HeadContent />
      </head>
      <body className={styles.body}>
        {children}
        <Scripts />
      </body>
    </html>
  );
}
