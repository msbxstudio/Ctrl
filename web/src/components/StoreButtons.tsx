"use client";

import { useI18n } from "@/lib/i18n";

const APP_STORE_URL = "#";
const GOOGLE_PLAY_URL = "#";

export function StoreButtons({ size = "md" }: { size?: "md" | "lg" }) {
  const { t } = useI18n();
  const sizeClass = size === "lg" ? " store-btn--lg" : "";

  return (
    <div className="store-buttons">
      <a
        href={APP_STORE_URL}
        aria-label={t.hero.appStore}
        className={`store-btn store-btn--apple${sizeClass}`}
      >
        <AppleIcon />
        <span className="store-btn__text">
          <span className="store-btn__label">{t.hero.comingSoon}</span>
          <span className="store-btn__name">{t.hero.appStore}</span>
        </span>
      </a>
      <a
        href={GOOGLE_PLAY_URL}
        aria-label={t.hero.googlePlay}
        className={`store-btn store-btn--google${sizeClass}`}
      >
        <PlayIcon />
        <span className="store-btn__text">
          <span className="store-btn__label">{t.hero.comingSoon}</span>
          <span className="store-btn__name">{t.hero.googlePlay}</span>
        </span>
      </a>
    </div>
  );
}

function AppleIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true" className="store-btn__icon">
      <path d="M16.365 1.43c0 1.14-.42 2.23-1.16 3.04-.79.87-2.07 1.55-3.13 1.47-.13-1.11.43-2.27 1.13-3.02.78-.85 2.13-1.49 3.16-1.49zM20.5 17.07c-.55 1.27-.82 1.84-1.53 2.97-.99 1.57-2.39 3.53-4.12 3.55-1.54.02-1.94-1-4.03-.99-2.09.01-2.53 1.01-4.07.99-1.73-.02-3.05-1.79-4.04-3.36C.05 16.66-.24 11.6 2.17 8.94c1.71-1.89 4.41-3 6.95-3 1 0 1.74.27 2.61.6.74.28 1.62.61 2.74.55.9-.04 1.92-.39 2.94-.69 1.06-.32 2.05-.6 3.13-.42-2.61.62-3.66 2.59-3.65 4.39 0 2.06 1.45 3.69 3.27 4.7-.36 1.05-.78 2.05-1.66 3z" />
    </svg>
  );
}

function PlayIcon() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true" className="store-btn__icon">
      <path d="M3.6 2.3 14 12 3.6 21.7c-.4-.2-.6-.6-.6-1.1V3.4c0-.5.2-.9.6-1.1z" fill="#FF7914" />
      <path d="m14 12 3.5-3.5 3.6 2c.7.4.7 1.5 0 1.9l-3.6 2L14 12z" fill="#BBC7DB" />
      <path d="M3.6 2.3c.2-.1.5-.1.8 0L17.5 9.5 14 12 3.6 2.3z" fill="#D6BEE4" />
      <path d="M14 12l3.5 3.5L4.4 22c-.3.1-.6.1-.8 0L14 12z" fill="#FFFFFF" />
    </svg>
  );
}
