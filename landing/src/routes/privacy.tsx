import { createFileRoute } from "@tanstack/react-router";
import { LegalLayout } from "@/components/LegalLayout";
import { useI18n } from "@/lib/i18n";

export const Route = createFileRoute("/privacy")({
  head: () => ({
    meta: [
      { title: "Privacy Policy — CTRL" },
      { name: "description", content: "How CTRL handles your data. No accounts, local progress, offline-first." },
      { property: "og:title", content: "Privacy Policy — CTRL" },
      { property: "og:description", content: "How CTRL handles your data." },
      { property: "og:url", content: "/privacy" },
    ],
    links: [{ rel: "canonical", href: "/privacy" }],
  }),
  component: PrivacyPage,
});

function PrivacyPage() {
  const { t } = useI18n();
  return <LegalLayout title={t.legal.privacy.title} intro={t.legal.privacy.intro} sections={t.legal.privacy.sections} />;
}
