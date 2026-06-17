"use client";

import { I18nProvider, useI18n } from "@/lib/i18n";
import { LegalLayout } from "@/components/LegalLayout";

export default function DonationsPage() {
  return (
    <I18nProvider>
      <DonationsContent />
    </I18nProvider>
  );
}

function DonationsContent() {
  const { t } = useI18n();
  return <LegalLayout title={t.legal.donations.title} intro={t.legal.donations.intro} sections={t.legal.donations.sections} />;
}
