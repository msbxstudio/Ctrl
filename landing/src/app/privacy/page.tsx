"use client";

import { I18nProvider, useI18n } from "@/lib/i18n";
import { LegalLayout } from "@/components/LegalLayout";

export default function PrivacyPage() {
  return (
    <I18nProvider>
      <PrivacyContent />
    </I18nProvider>
  );
}

function PrivacyContent() {
  const { t } = useI18n();
  return <LegalLayout title={t.legal.privacy.title} intro={t.legal.privacy.intro} sections={t.legal.privacy.sections} />;
}
