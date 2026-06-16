import { useI18n, type Lang } from "@/lib/i18n";

export function LangSwitcher() {
  const { lang, setLang } = useI18n();
  const opts: { value: Lang; label: string }[] = [
    { value: "en", label: "EN" },
    { value: "es", label: "ES" },
  ];
  return (
    <div
      role="group"
      aria-label="Language"
      className="inline-flex items-center rounded-full border border-border bg-[var(--color-elevated)]/60 p-0.5 text-xs"
    >
      {opts.map((o) => {
        const active = lang === o.value;
        return (
          <button
            key={o.value}
            type="button"
            onClick={() => setLang(o.value)}
            aria-pressed={active}
            className={`rounded-full px-2.5 py-1 font-medium transition ${
              active
                ? "bg-foreground text-background"
                : "text-muted-foreground hover:text-foreground"
            }`}
          >
            {o.label}
          </button>
        );
      })}
    </div>
  );
}