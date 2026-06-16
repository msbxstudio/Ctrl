import { createFileRoute } from "@tanstack/react-router";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { StoreButtons } from "@/components/StoreButtons";
import { useI18n } from "@/lib/i18n";
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion";

export const Route = createFileRoute("/")({
  head: () => ({
    meta: [
      { title: "CTRL — Developer puzzles. Zero friction." },
      {
        name: "description",
        content:
          "CTRL is a minimalist puzzle game for developers. Short programming puzzles, one-handed play, offline first. Just one more level.",
      },
      { name: "keywords", content: "developer puzzle game, programming puzzles, coding brain training, logic game for developers, programming challenges" },
      { property: "og:title", content: "CTRL — Developer puzzles. Zero friction." },
      { property: "og:description", content: "Short programming puzzles. One-handed. Offline. Just one more level." },
      { property: "og:url", content: "/" },
      { property: "og:type", content: "website" },
      { name: "twitter:title", content: "CTRL — Developer puzzles. Zero friction." },
      { name: "twitter:description", content: "Short programming puzzles. One-handed. Offline." },
    ],
    links: [{ rel: "canonical", href: "/" }],
  }),
  component: LandingPage,
});

function LandingPage() {
  const { t } = useI18n();
  return (
    <>
      <SiteHeader />

      {/* HERO */}
      <section id="download" className="relative overflow-hidden">
        <div
          aria-hidden="true"
          className="pointer-events-none absolute inset-0 -z-10"
          style={{
            background:
              "radial-gradient(60% 50% at 50% 0%, rgba(255,121,20,0.10), transparent 70%)",
          }}
        />
        <div className="mx-auto max-w-5xl px-5 pt-20 pb-24 text-center sm:pt-28 sm:pb-32">
          <div className="mx-auto mb-6 inline-flex items-center gap-2 rounded-full border border-border bg-[var(--color-elevated)]/60 px-3 py-1 text-xs text-muted-foreground">
            <span className="h-1.5 w-1.5 rounded-full bg-primary" />
            CTRL · Mobile · {t.hero.comingSoon}
          </div>
          <h1 className="mx-auto max-w-3xl text-balance text-5xl font-extrabold tracking-tight sm:text-6xl md:text-7xl">
            {t.hero.tagline}
          </h1>
          <p className="mx-auto mt-6 max-w-xl text-balance text-base text-muted-foreground sm:text-lg">
            {t.hero.description}
          </p>
          <div className="mt-10 flex justify-center">
            <StoreButtons size="lg" />
          </div>

          <div className="mt-20 flex justify-center">
            <PhoneMock />
          </div>
        </div>
      </section>

      {/* HOW */}
      <section id="how" className="border-t border-border/60">
        <div className="mx-auto max-w-6xl px-5 py-24">
          <SectionEyebrow>{t.how.eyebrow}</SectionEyebrow>
          <h2 className="mt-3 max-w-2xl text-3xl font-bold tracking-tight sm:text-4xl">
            {t.how.title}
          </h2>
          <div className="mt-12 grid gap-6 md:grid-cols-3">
            {[
              { key: "solve" as const, icon: <PuzzleIcon /> },
              { key: "tap" as const, icon: <TapIcon /> },
              { key: "repeat" as const, icon: <LoopIcon /> },
            ].map((b, i) => {
              const block = t.how[b.key];
              return (
                <div
                  key={b.key}
                  className="group rounded-2xl border border-border bg-card p-7 transition hover:border-primary/40"
                >
                  <div className="flex items-center justify-between">
                    <div className="grid h-11 w-11 place-items-center rounded-xl bg-[var(--color-elevated)] text-foreground">
                      {b.icon}
                    </div>
                    <span className="font-mono text-xs text-muted-foreground">0{i + 1}</span>
                  </div>
                  <h3 className="mt-6 text-lg font-semibold">{block.title}</h3>
                  <p className="mt-1 text-sm text-muted-foreground">{block.desc}</p>
                </div>
              );
            })}
          </div>
        </div>
      </section>

      {/* FEATURES */}
      <section id="features" className="border-t border-border/60">
        <div className="mx-auto max-w-6xl px-5 py-24">
          <SectionEyebrow>{t.features.eyebrow}</SectionEyebrow>
          <h2 className="mt-3 max-w-2xl text-3xl font-bold tracking-tight sm:text-4xl">
            {t.features.title}
          </h2>
          <div className="mt-12 grid gap-px overflow-hidden rounded-2xl border border-border bg-border sm:grid-cols-2 lg:grid-cols-3">
            {t.features.items.map((f) => (
              <div key={f.t} className="bg-card p-7">
                <div className="mb-4 h-1 w-6 rounded-full bg-primary" />
                <h3 className="text-base font-semibold">{f.t}</h3>
                <p className="mt-1 text-sm text-muted-foreground">{f.d}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* PREVIEW */}
      <section id="preview" className="border-t border-border/60">
        <div className="mx-auto max-w-6xl px-5 py-24">
          <SectionEyebrow>{t.preview.eyebrow}</SectionEyebrow>
          <div className="mt-3 flex flex-wrap items-end justify-between gap-4">
            <h2 className="max-w-2xl text-3xl font-bold tracking-tight sm:text-4xl">
              {t.preview.title}
            </h2>
            <p className="max-w-sm text-sm text-muted-foreground">{t.preview.desc}</p>
          </div>

          <div className="mt-12 -mx-5 overflow-x-auto px-5 pb-2 md:hidden">
            <div className="flex gap-4">
              {[0, 1, 2, 3].map((i) => (
                <ScreenshotPlaceholder key={i} index={i} className="w-[68vw] shrink-0" />
              ))}
            </div>
          </div>
          <div className="mt-12 hidden gap-6 md:grid md:grid-cols-4">
            {[0, 1, 2, 3].map((i) => (
              <ScreenshotPlaceholder key={i} index={i} />
            ))}
          </div>
        </div>
      </section>

      {/* FAQ */}
      <section id="faq" className="border-t border-border/60">
        <div className="mx-auto max-w-3xl px-5 py-24">
          <SectionEyebrow>{t.faq.eyebrow}</SectionEyebrow>
          <h2 className="mt-3 text-3xl font-bold tracking-tight sm:text-4xl">{t.faq.title}</h2>
          <Accordion type="single" collapsible className="mt-10">
            {t.faq.items.map((item, i) => (
              <AccordionItem key={i} value={`item-${i}`} className="border-border/60">
                <AccordionTrigger className="text-left text-base font-medium hover:no-underline">
                  {item.q}
                </AccordionTrigger>
                <AccordionContent className="text-muted-foreground">
                  {item.a}
                </AccordionContent>
              </AccordionItem>
            ))}
          </Accordion>
        </div>
      </section>

      {/* SUPPORT */}
      <section className="border-t border-border/60">
        <div className="mx-auto max-w-3xl px-5 py-24 text-center">
          <SectionEyebrow center>{t.support.eyebrow}</SectionEyebrow>
          <h2 className="mt-3 text-3xl font-bold tracking-tight sm:text-4xl">{t.support.title}</h2>
          <p className="mx-auto mt-5 max-w-xl text-sm text-muted-foreground">
            {t.support.desc}
          </p>
          <button
            type="button"
            disabled
            aria-disabled="true"
            className="mt-8 inline-flex cursor-not-allowed items-center gap-2 rounded-full border border-border bg-[var(--color-elevated)] px-5 py-2.5 text-sm font-medium text-foreground/80 opacity-80"
          >
            <HeartIcon className="h-4 w-4 text-primary" />
            {t.support.cta}
          </button>
        </div>
      </section>

      <SiteFooter />
    </>
  );
}

function SectionEyebrow({ children, center = false }: { children: React.ReactNode; center?: boolean }) {
  return (
    <div className={`flex items-center gap-2 font-mono text-xs uppercase tracking-[0.18em] text-muted-foreground ${center ? "justify-center" : ""}`}>
      <span className="h-px w-6 bg-border" />
      <span>{children}</span>
    </div>
  );
}

function PhoneMock() {
  return (
    <div className="relative w-[280px] sm:w-[320px]">
      <div className="rounded-[2.5rem] border border-border bg-[var(--color-elevated)] p-2 shadow-2xl">
        <div className="overflow-hidden rounded-[2rem] bg-background">
          <div className="flex items-center justify-between px-5 pt-4 font-mono text-[10px] text-muted-foreground">
            <span>9:41</span>
            <span>CTRL</span>
            <span>●●●</span>
          </div>
          <div className="px-5 pt-6">
            <div className="font-mono text-[10px] uppercase tracking-widest text-muted-foreground">
              Level 042
            </div>
            <div className="mt-3 rounded-xl bg-[var(--color-elevated)] p-4 font-mono text-xs leading-relaxed text-foreground">
              <div><span className="text-muted-foreground">{">"}</span> let x = [1,2,3]</div>
              <div><span className="text-muted-foreground">{">"}</span> x.map(n =&gt; n * 2)</div>
              <div className="mt-2 text-primary">// returns ?</div>
            </div>
            <div className="mt-6 grid grid-cols-4 gap-2">
              {["[1,2,3]", "[2,4,6]", "[3,6,9]", "null"].map((opt, i) => (
                <div
                  key={i}
                  className={`rounded-lg px-2 py-3 text-center font-mono text-[11px] ${
                    i === 1
                      ? "bg-primary text-primary-foreground"
                      : "bg-[var(--color-elevated)] text-foreground/80"
                  }`}
                >
                  {opt}
                </div>
              ))}
            </div>
            <div className="mt-6 flex items-center justify-between pb-6">
              <div className="flex gap-1">
                {[0,1,2].map((i) => (
                  <span key={i} className={`h-1 w-6 rounded-full ${i === 0 ? "bg-primary" : "bg-border"}`} />
                ))}
              </div>
              <span className="font-mono text-[10px] text-muted-foreground">00:04</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function ScreenshotPlaceholder({ index, className = "" }: { index: number; className?: string }) {
  const { t } = useI18n();
  return (
    <div
      className={`aspect-[9/19] rounded-[2rem] border border-border bg-gradient-to-b from-[var(--color-elevated)] to-card p-4 ${className}`}
    >
      <div className="flex h-full flex-col items-center justify-center gap-2 rounded-[1.6rem] border border-dashed border-border/60 text-center">
        <span className="font-mono text-[10px] uppercase tracking-widest text-muted-foreground">
          {t.preview.placeholder} 0{index + 1}
        </span>
      </div>
    </div>
  );
}

function PuzzleIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" className="h-5 w-5" aria-hidden="true">
      <path d="M10 3h4v3a2 2 0 1 0 4 0V3h3v4h-3a2 2 0 1 0 0 4h3v7h-7v-3a2 2 0 1 0-4 0v3H3v-7h3a2 2 0 1 0 0-4H3V3h7z" strokeLinejoin="round" />
    </svg>
  );
}
function TapIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" className="h-5 w-5" aria-hidden="true">
      <path d="M9 11V6a2 2 0 1 1 4 0v6" />
      <path d="M13 9a2 2 0 1 1 4 0v5" />
      <path d="M17 11a2 2 0 1 1 4 0v6a5 5 0 0 1-5 5h-2a6 6 0 0 1-6-6v-5a2 2 0 1 1 4 0" />
    </svg>
  );
}
function LoopIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" className="h-5 w-5" aria-hidden="true">
      <path d="M17 4l4 4-4 4" />
      <path d="M3 12V10a4 4 0 0 1 4-4h14" />
      <path d="M7 20l-4-4 4-4" />
      <path d="M21 12v2a4 4 0 0 1-4 4H3" />
    </svg>
  );
}
function HeartIcon({ className = "" }: { className?: string }) {
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" className={className} aria-hidden="true">
      <path d="M12 21s-7-4.5-9.5-9A5.5 5.5 0 0 1 12 6a5.5 5.5 0 0 1 9.5 6c-2.5 4.5-9.5 9-9.5 9z" />
    </svg>
  );
}