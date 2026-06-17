"use client";

import Link from "next/link";
import { SiteHeader } from "./SiteHeader";
import { SiteFooter } from "./SiteFooter";
import { useI18n } from "@/lib/i18n";

type Section = { h: string; p: string };

export function LegalLayout({
  title,
  intro,
  sections,
}: {
  title: string;
  intro: string;
  sections: readonly Section[];
}) {
  const { t } = useI18n();
  return (
    <>
      <SiteHeader />
      <article className="legal">
        <Link href="/" className="legal__back">
          ← {t.legal.back}
        </Link>
        <h1 className="legal__title">{title}</h1>
        <p className="legal__date">{t.legal.lastUpdated}: 2026-06-13</p>
        <p className="legal__intro">{intro}</p>
        <div className="legal__sections">
          {sections.map((s, i) => (
            <section key={i}>
              <h2 className="legal__section-title">{s.h}</h2>
              <p className="legal__section-text">{s.p}</p>
            </section>
          ))}
        </div>
      </article>
      <SiteFooter />
    </>
  );
}
