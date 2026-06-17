"use client";

import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { StoreButtons } from "@/components/StoreButtons";
import { Accordion, AccordionItem, AccordionTrigger, AccordionContent } from "@/components/Accordion";
import { useI18n } from "@/lib/i18n";

export function LandingPage() {
  const { t } = useI18n();
  return (
    <>
      <SiteHeader />

      {/* HERO */}
      <section id="download" className="hero">
        <div aria-hidden="true" className="hero__glow" />
        <div className="hero__inner">
          <div className="hero__badge">
            <span className="hero__badge-dot" />
            CTRL · Mobile · {t.hero.comingSoon}
          </div>
          <h1 className="hero__title">{t.hero.tagline}</h1>
          <p className="hero__desc">{t.hero.description}</p>
          <div className="hero__buttons">
            <StoreButtons size="lg" />
          </div>
          <div className="hero__phone">
            <PhoneMock />
          </div>
        </div>
      </section>

      {/* HOW */}
      <section id="how" className="section">
        <div className="section__inner">
          <SectionEyebrow>{t.how.eyebrow}</SectionEyebrow>
          <h2 className="section__title">{t.how.title}</h2>
          <div className="how-grid">
            {[
              { key: "solve" as const, icon: <PuzzleIcon /> },
              { key: "tap" as const, icon: <TapIcon /> },
              { key: "repeat" as const, icon: <LoopIcon /> },
            ].map((b, i) => {
              const block = t.how[b.key];
              return (
                <div key={b.key} className="how-card">
                  <div className="how-card__header">
                    <div className="how-card__icon">{b.icon}</div>
                    <span className="how-card__number">0{i + 1}</span>
                  </div>
                  <h3 className="how-card__title">{block.title}</h3>
                  <p className="how-card__desc">{block.desc}</p>
                </div>
              );
            })}
          </div>
        </div>
      </section>

      {/* FEATURES */}
      <section id="features" className="section">
        <div className="section__inner">
          <SectionEyebrow>{t.features.eyebrow}</SectionEyebrow>
          <h2 className="section__title">{t.features.title}</h2>
          <div className="features-grid">
            {t.features.items.map((f) => (
              <div key={f.t} className="feature-item">
                <div className="feature-item__bar" />
                <h3 className="feature-item__title">{f.t}</h3>
                <p className="feature-item__desc">{f.d}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* PREVIEW */}
      <section id="preview" className="section">
        <div className="section__inner">
          <SectionEyebrow>{t.preview.eyebrow}</SectionEyebrow>
          <div className="preview-header">
            <h2 className="section__title">{t.preview.title}</h2>
            <p className="preview-header__desc">{t.preview.desc}</p>
          </div>
          <div className="preview-scroll">
            <div className="preview-scroll__inner">
              {[0, 1, 2, 3].map((i) => (
                <ScreenshotPlaceholder key={i} index={i} mobile />
              ))}
            </div>
          </div>
          <div className="preview-grid">
            {[0, 1, 2, 3].map((i) => (
              <ScreenshotPlaceholder key={i} index={i} />
            ))}
          </div>
        </div>
      </section>

      {/* FAQ */}
      <section id="faq" className="section">
        <div className="section__inner section__inner--narrow">
          <SectionEyebrow>{t.faq.eyebrow}</SectionEyebrow>
          <h2 className="section__title">{t.faq.title}</h2>
          <Accordion type="single" collapsible>
            {t.faq.items.map((item, i) => (
              <AccordionItem key={i} value={`item-${i}`}>
                <AccordionTrigger>{item.q}</AccordionTrigger>
                <AccordionContent>{item.a}</AccordionContent>
              </AccordionItem>
            ))}
          </Accordion>
        </div>
      </section>

      {/* SUPPORT */}
      <section className="section">
        <div className="section__inner section__inner--narrow section__inner--center">
          <SectionEyebrow center>{t.support.eyebrow}</SectionEyebrow>
          <h2 className="section__title" style={{ margin: "0.75rem auto 0" }}>{t.support.title}</h2>
          <p className="section__desc">{t.support.desc}</p>
          <button type="button" disabled aria-disabled="true" className="support-btn">
            <HeartIcon />
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
    <div className={`section-eyebrow${center ? " section-eyebrow--center" : ""}`}>
      <span className="section-eyebrow__line" />
      <span>{children}</span>
    </div>
  );
}

function PhoneMock() {
  return (
    <div className="phone-mock">
      <div className="phone-mock__frame">
        <div className="phone-mock__screen">
          <div className="phone-mock__statusbar">
            <span>9:41</span>
            <span>CTRL</span>
            <span>●●●</span>
          </div>
          <div className="phone-mock__content">
            <div className="phone-mock__level">Level 042</div>
            <div className="phone-mock__code">
              <div><span className="phone-mock__code-comment">{">"}</span> let x = [1,2,3]</div>
              <div><span className="phone-mock__code-comment">{">"}</span> x.map(n =&gt; n * 2)</div>
              <div className="phone-mock__code-result">// returns ?</div>
            </div>
            <div className="phone-mock__options">
              {["[1,2,3]", "[2,4,6]", "[3,6,9]", "null"].map((opt, i) => (
                <div
                  key={i}
                  className={`phone-mock__option${i === 1 ? " phone-mock__option--active" : ""}`}
                >
                  {opt}
                </div>
              ))}
            </div>
            <div className="phone-mock__footer">
              <div className="phone-mock__progress">
                {[0, 1, 2].map((i) => (
                  <span key={i} className={`phone-mock__progress-bar${i === 0 ? " phone-mock__progress-bar--active" : ""}`} />
                ))}
              </div>
              <span className="phone-mock__timer">00:04</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function ScreenshotPlaceholder({ index, mobile = false }: { index: number; mobile?: boolean }) {
  const { t } = useI18n();
  return (
    <div className={`screenshot-placeholder${mobile ? " screenshot-placeholder--mobile" : ""}`}>
      <div className="screenshot-placeholder__inner">
        <span className="screenshot-placeholder__label">
          {t.preview.placeholder} 0{index + 1}
        </span>
      </div>
    </div>
  );
}

function PuzzleIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" aria-hidden="true">
      <path d="M10 3h4v3a2 2 0 1 0 4 0V3h3v4h-3a2 2 0 1 0 0 4h3v7h-7v-3a2 2 0 1 0-4 0v3H3v-7h3a2 2 0 1 0 0-4H3V3h7z" strokeLinejoin="round" />
    </svg>
  );
}

function TapIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M9 11V6a2 2 0 1 1 4 0v6" />
      <path d="M13 9a2 2 0 1 1 4 0v5" />
      <path d="M17 11a2 2 0 1 1 4 0v6a5 5 0 0 1-5 5h-2a6 6 0 0 1-6-6v-5a2 2 0 1 1 4 0" />
    </svg>
  );
}

function LoopIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M17 4l4 4-4 4" />
      <path d="M3 12V10a4 4 0 0 1 4-4h14" />
      <path d="M7 20l-4-4 4-4" />
      <path d="M21 12v2a4 4 0 0 1-4 4H3" />
    </svg>
  );
}

function HeartIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" className="support-btn__icon" aria-hidden="true">
      <path d="M12 21s-7-4.5-9.5-9A5.5 5.5 0 0 1 12 6a5.5 5.5 0 0 1 9.5 6c-2.5 4.5-9.5 9-9.5 9z" />
    </svg>
  );
}
