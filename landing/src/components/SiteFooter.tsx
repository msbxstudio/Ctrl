"use client";

import Link from "next/link";
import { CtrlLogo } from "./CtrlLogo";
import { useI18n } from "@/lib/i18n";

export function SiteFooter() {
  const { t } = useI18n();
  return (
    <footer className="site-footer">
      <div className="site-footer__grid">
        <div>
          <CtrlLogo />
          <p className="site-footer__tagline">{t.footer.tagline}</p>
        </div>
        <div>
          <h3 className="site-footer__heading">{t.footer.product}</h3>
          <ul className="site-footer__list">
            <li><a href="#">{t.footer.appStore}</a></li>
            <li><a href="#">{t.footer.googlePlay}</a></li>
            <li><a href="mailto:hello@ctrl.app">{t.footer.contact}</a></li>
          </ul>
        </div>
        <div>
          <h3 className="site-footer__heading">{t.footer.legal}</h3>
          <ul className="site-footer__list">
            <li><Link href="/privacy">{t.footer.privacy}</Link></li>
            <li><Link href="/terms">{t.footer.terms}</Link></li>
            <li><Link href="/donations">{t.footer.donations}</Link></li>
          </ul>
        </div>
      </div>
      <div className="site-footer__bottom">
        <div className="site-footer__bottom-inner">
          <span>{t.footer.rights}</span>
        </div>
      </div>
    </footer>
  );
}
