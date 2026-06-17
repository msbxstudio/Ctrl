"use client";

import { I18nProvider } from "@/lib/i18n";
import Link from "next/link";

export default function NotFound() {
  return (
    <I18nProvider>
      <div className="not-found">
        <div className="not-found__inner">
          <h1 className="not-found__code">404</h1>
          <h2 className="not-found__title">Page not found</h2>
          <p className="not-found__desc">
            The page you&apos;re looking for doesn&apos;t exist or has been moved.
          </p>
          <Link href="/" className="not-found__link">Go home</Link>
        </div>
      </div>
    </I18nProvider>
  );
}
