"use client";

import { I18nProvider, useI18n } from "@/lib/i18n";
import { LegalLayout } from "@/components/LegalLayout";

export default function TermsPage() {
  return (
    <I18nProvider>
      <TermsContent />
    </I18nProvider>
  );
}

function TermsContent() {
  const { t } = useI18n();
  return <LegalLayout title={t.legal.terms.title} intro={t.legal.terms.intro} sections={t.legal.terms.sections} />;
}
