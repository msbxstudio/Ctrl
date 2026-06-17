"use client";

import { useI18n, type Lang } from "@/lib/i18n";

export function LangSwitcher() {
  const { lang, setLang } = useI18n();
  const opts: { value: Lang; label: string }[] = [
    { value: "en", label: "EN" },
    { value: "es", label: "ES" },
  ];
  return (
    <div role="group" aria-label="Language" className="lang-switcher">
      {opts.map((o) => {
        const active = lang === o.value;
        return (
          <button
            key={o.value}
            type="button"
            onClick={() => setLang(o.value)}
            aria-pressed={active}
            className={`lang-switcher__btn${active ? " lang-switcher__btn--active" : ""}`}
          >
            {o.label}
          </button>
        );
      })}
    </div>
  );
}
