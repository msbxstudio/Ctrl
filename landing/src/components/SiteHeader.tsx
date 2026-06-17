"use client";

import Link from "next/link";
import { CtrlLogo } from "./CtrlLogo";
import { LangSwitcher } from "./LangSwitcher";
import { useI18n } from "@/lib/i18n";

export function SiteHeader() {
  const { t } = useI18n();
  return (
    <header className="site-header">
      <div className="site-header__inner">
        <Link href="/" aria-label="CTRL — home">
          <CtrlLogo />
        </Link>
        <nav className="site-header__nav" aria-label="Primary">
          <a href="/#how">{t.nav.how}</a>
          <a href="/#features">{t.nav.features}</a>
          <a href="/#preview">{t.nav.preview}</a>
          <a href="/#faq">{t.nav.faq}</a>
        </nav>
        <div className="site-header__actions">
          <LangSwitcher />
          <a href="/#download" className="site-header__download">
            {t.nav.download}
          </a>
        </div>
      </div>
    </header>
  );
}
