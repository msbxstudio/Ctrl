import { Link } from "@tanstack/react-router";
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
      <article className="mx-auto max-w-3xl px-5 py-20">
        <Link to="/" className="font-mono text-xs uppercase tracking-widest text-muted-foreground hover:text-foreground">
          ← {t.legal.back}
        </Link>
        <h1 className="mt-6 text-4xl font-bold tracking-tight sm:text-5xl">{title}</h1>
        <p className="mt-4 text-sm text-muted-foreground">{t.legal.lastUpdated}: 2026-06-13</p>
        <p className="mt-8 text-base text-foreground/90">{intro}</p>
        <div className="mt-10 space-y-8">
          {sections.map((s, i) => (
            <section key={i}>
              <h2 className="text-lg font-semibold">{s.h}</h2>
              <p className="mt-2 text-sm leading-relaxed text-muted-foreground">{s.p}</p>
            </section>
          ))}
        </div>
      </article>
      <SiteFooter />
    </>
  );
}
