import { createFileRoute } from "@tanstack/react-router";
import { LegalLayout } from "@/components/LegalLayout";
import { useI18n } from "@/lib/i18n";

export const Route = createFileRoute("/terms")({
  head: () => ({
    meta: [
      { title: "Terms of Use — CTRL" },
      { name: "description", content: "Terms of use for CTRL." },
      { property: "og:title", content: "Terms of Use — CTRL" },
      { property: "og:description", content: "Terms of use for CTRL." },
      { property: "og:url", content: "/terms" },
    ],
    links: [{ rel: "canonical", href: "/terms" }],
  }),
  component: TermsPage,
});

function TermsPage() {
  const { t } = useI18n();
  return <LegalLayout title={t.legal.terms.title} intro={t.legal.terms.intro} sections={t.legal.terms.sections} />;
}
