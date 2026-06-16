import { Link } from "@tanstack/react-router";
import { CtrlLogo } from "./CtrlLogo";
import { useI18n } from "@/lib/i18n";

export function SiteFooter() {
  const { t } = useI18n();
  return (
    <footer className="border-t border-border/60 bg-background">
      <div className="mx-auto grid max-w-6xl gap-10 px-5 py-12 md:grid-cols-[1.5fr_1fr_1fr]">
        <div>
          <CtrlLogo />
          <p className="mt-3 max-w-xs text-sm text-muted-foreground">{t.footer.tagline}</p>
        </div>
        <div>
          <h3 className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">
            {t.footer.product}
          </h3>
          <ul className="mt-3 space-y-2 text-sm">
            <li><a href="#" className="text-foreground/80 hover:text-foreground">{t.footer.appStore}</a></li>
            <li><a href="#" className="text-foreground/80 hover:text-foreground">{t.footer.googlePlay}</a></li>
            <li><a href="mailto:hello@ctrl.app" className="text-foreground/80 hover:text-foreground">{t.footer.contact}</a></li>
          </ul>
        </div>
        <div>
          <h3 className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">
            {t.footer.legal}
          </h3>
          <ul className="mt-3 space-y-2 text-sm">
            <li><Link to="/privacy" className="text-foreground/80 hover:text-foreground">{t.footer.privacy}</Link></li>
            <li><Link to="/terms" className="text-foreground/80 hover:text-foreground">{t.footer.terms}</Link></li>
            <li><Link to="/donations" className="text-foreground/80 hover:text-foreground">{t.footer.donations}</Link></li>
          </ul>
        </div>
      </div>
      <div className="border-t border-border/60">
        <div className="mx-auto flex max-w-6xl items-center justify-between px-5 py-5 text-xs text-muted-foreground">
          <span>{t.footer.rights}</span>
        </div>
      </div>
    </footer>
  );
}