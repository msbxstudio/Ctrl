import { Link } from "@tanstack/react-router";
import { CtrlLogo } from "./CtrlLogo";
import { LangSwitcher } from "./LangSwitcher";
import { useI18n } from "@/lib/i18n";

export function SiteHeader() {
  const { t } = useI18n();
  return (
    <header className="sticky top-0 z-40 border-b border-border/60 bg-background/80 backdrop-blur">
      <div className="mx-auto flex h-14 max-w-6xl items-center justify-between gap-4 px-5">
        <Link to="/" className="shrink-0" aria-label="CTRL — home">
          <CtrlLogo />
        </Link>
        <nav className="hidden items-center gap-7 text-sm text-muted-foreground md:flex" aria-label="Primary">
          <a href="/#how" className="hover:text-foreground">{t.nav.how}</a>
          <a href="/#features" className="hover:text-foreground">{t.nav.features}</a>
          <a href="/#preview" className="hover:text-foreground">{t.nav.preview}</a>
          <a href="/#faq" className="hover:text-foreground">{t.nav.faq}</a>
        </nav>
        <div className="flex items-center gap-3">
          <LangSwitcher />
          <a
            href="/#download"
            className="hidden rounded-full bg-primary px-3.5 py-1.5 text-sm font-semibold text-primary-foreground hover:opacity-95 sm:inline-flex"
          >
            {t.nav.download}
          </a>
        </div>
      </div>
    </header>
  );
}