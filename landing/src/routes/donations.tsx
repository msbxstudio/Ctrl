import { createFileRoute } from "@tanstack/react-router";
import { LegalLayout } from "@/components/LegalLayout";
import { useI18n } from "@/lib/i18n";

export const Route = createFileRoute("/donations")({
  head: () => ({
    meta: [
      { title: "Donations & Support — CTRL" },
      { name: "description", content: "How donations work for CTRL: voluntary, non-refundable, no advantage." },
      { property: "og:title", content: "Donations & Support — CTRL" },
      { property: "og:description", content: "Donations are voluntary and optional." },
      { property: "og:url", content: "/donations" },
    ],
    links: [{ rel: "canonical", href: "/donations" }],
  }),
  component: DonationsPage,
});

function DonationsPage() {
  const { t } = useI18n();
  return <LegalLayout title={t.legal.donations.title} intro={t.legal.donations.intro} sections={t.legal.donations.sections} />;
}
