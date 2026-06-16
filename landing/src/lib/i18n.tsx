import { createContext, useContext, useEffect, useState, type ReactNode } from "react";

export type Lang = "en" | "es";

export const translations = {
  en: {
    nav: {
      how: "How it works",
      features: "Features",
      preview: "Preview",
      faq: "FAQ",
      download: "Download",
    },
    hero: {
      tagline: "Developer puzzles. Zero friction.",
      description:
        "Short developer puzzles designed to be solved in seconds. No typing. No setup. Just one more level.",
      appStore: "Download on the App Store",
      googlePlay: "Get it on Google Play",
      comingSoon: "Coming soon",
    },
    how: {
      eyebrow: "How it works",
      title: "Three steps. That's it.",
      solve: { title: "Solve", desc: "Short programming puzzles." },
      tap: { title: "Tap", desc: "Answer using a fixed keyboard layout." },
      repeat: { title: "Repeat", desc: "Keep the flow going. One more level." },
    },
    features: {
      eyebrow: "What makes CTRL different",
      title: "Built for momentum.",
      items: [
        { t: "No typing", d: "Tap. Don't write." },
        { t: "Offline first", d: "Plays anywhere, anytime." },
        { t: "One-handed play", d: "Thumb-friendly by design." },
        { t: "Muscle memory", d: "Fixed layout. Faster every run." },
        { t: "Fast sessions", d: "Seconds per level." },
        { t: "Hundreds of levels", d: "Always one more." },
      ],
    },
    preview: {
      eyebrow: "Preview",
      title: "Made to feel like nothing.",
      desc: "Designed for one thumb, one screen, one more level.",
      placeholder: "Screenshot",
    },
    faq: {
      eyebrow: "FAQ",
      title: "Questions, answered.",
      items: [
        { q: "Is CTRL an educational app?", a: "No. It's a puzzle game inspired by programming logic." },
        { q: "Does it require an account?", a: "No. No registration is needed." },
        { q: "Does it work offline?", a: "Yes. The game is designed to work completely offline." },
        { q: "Is my data collected?", a: "No personal accounts are required and gameplay data remains local on your device." },
        { q: "Is CTRL free?", a: "Yes. CTRL can be downloaded for free." },
      ],
    },
    support: {
      eyebrow: "Support CTRL",
      title: "Free to play. Yours to support.",
      desc: "CTRL can be enjoyed for free. If you'd like to support its development, optional donations may be available. Donations are voluntary, don't affect gameplay, and aren't required.",
      cta: "Support the project",
    },
    footer: {
      tagline: "Developer puzzles. Zero friction.",
      product: "Product",
      legal: "Legal",
      appStore: "App Store",
      googlePlay: "Google Play",
      privacy: "Privacy Policy",
      terms: "Terms of Use",
      donations: "Donations & Support",
      contact: "Contact",
      rights: "© CTRL. All rights reserved.",
    },
    legal: {
      back: "Back to home",
      lastUpdated: "Last updated",
      privacy: {
        title: "Privacy Policy",
        intro:
          "CTRL is a single-player puzzle game. We've designed it to require as little personal information as possible.",
        sections: [
          {
            h: "No account, no login",
            p: "CTRL does not require an account, email, or password. You can play immediately after installing the app.",
          },
          {
            h: "Local progress",
            p: "Your puzzle progress, settings, and statistics are stored locally on your device. We do not sync or upload them to any backend that we operate.",
          },
          {
            h: "Offline play",
            p: "CTRL is designed to run offline. Network connectivity is not required to play, and the core gameplay does not transmit data over the internet.",
          },
          {
            h: "Advertising (Google AdMob)",
            p: "CTRL may show occasional ads delivered by Google AdMob. AdMob may collect device identifiers and usage signals as described in Google's privacy policy. You can review and reset advertising identifiers in your device settings at any time.",
          },
          {
            h: "External links",
            p: "CTRL may link to external destinations such as the App Store or Google Play. We are not responsible for the privacy practices of third-party services.",
          },
          {
            h: "Children",
            p: "CTRL is suitable for general audiences and does not knowingly collect personal information from children.",
          },
          {
            h: "Changes",
            p: "This policy may be updated as the app evolves. The current version is always available on this page.",
          },
          {
            h: "Contact",
            p: "If you have questions about privacy, please reach out via the contact link in the footer.",
          },
        ],
      },
      terms: {
        title: "Terms of Use",
        intro: "By installing or using CTRL, you agree to the following terms.",
        sections: [
          {
            h: "License",
            p: "CTRL grants you a limited, personal, non-exclusive, non-transferable license to install and play the game on devices you own or control, for personal, non-commercial use.",
          },
          {
            h: "Restrictions",
            p: "You may not redistribute, sublicense, reverse engineer, decompile, or attempt to extract the source code or game content of CTRL, except where such restriction is prohibited by applicable law.",
          },
          {
            h: "Availability",
            p: "CTRL is provided as-is and as-available. We make no guarantees about uptime, compatibility with any particular device, or continued availability of the app or any specific level.",
          },
          {
            h: "Disclaimer",
            p: "To the maximum extent permitted by law, CTRL is provided without warranties of any kind, express or implied, including merchantability, fitness for a particular purpose, and non-infringement.",
          },
          {
            h: "Changes",
            p: "These terms may be updated in the future. Continued use of CTRL after changes are posted constitutes acceptance of the revised terms.",
          },
        ],
      },
      donations: {
        title: "Donations & Support Policy",
        intro: "CTRL is free to play. Donations are entirely optional.",
        sections: [
          {
            h: "Voluntary",
            p: "Any donation made in support of CTRL is fully voluntary. Donations are not required to download, install, or enjoy the full game.",
          },
          {
            h: "No advantage",
            p: "Donations do not grant any competitive advantage, unlock essential features, or alter the gameplay experience in any way.",
          },
          {
            h: "Refunds",
            p: "Donations are non-refundable, except where a refund is required by applicable law.",
          },
          {
            h: "Purpose",
            p: "Donations help cover maintenance, ongoing development, and new content for CTRL.",
          },
        ],
      },
    },
  },
  es: {
    nav: {
      how: "Cómo funciona",
      features: "Características",
      preview: "Vista previa",
      faq: "Preguntas",
      download: "Descargar",
    },
    hero: {
      tagline: "Puzzles para devs. Cero fricción.",
      description:
        "Puzzles cortos de programación pensados para resolverse en segundos. Sin teclear. Sin configurar. Solo un nivel más.",
      appStore: "Descargar en App Store",
      googlePlay: "Disponible en Google Play",
      comingSoon: "Próximamente",
    },
    how: {
      eyebrow: "Cómo funciona",
      title: "Tres pasos. Nada más.",
      solve: { title: "Resuelve", desc: "Puzzles cortos de programación." },
      tap: { title: "Toca", desc: "Responde con un teclado fijo." },
      repeat: { title: "Repite", desc: "Mantén el flujo. Un nivel más." },
    },
    features: {
      eyebrow: "Qué hace diferente a CTRL",
      title: "Diseñado para el flujo.",
      items: [
        { t: "Sin teclear", d: "Tocas. No escribes." },
        { t: "Funciona offline", d: "Juega en cualquier lugar." },
        { t: "Una sola mano", d: "Pensado para el pulgar." },
        { t: "Memoria muscular", d: "Layout fijo. Más rápido en cada partida." },
        { t: "Sesiones rápidas", d: "Segundos por nivel." },
        { t: "Cientos de niveles", d: "Siempre uno más." },
      ],
    },
    preview: {
      eyebrow: "Vista previa",
      title: "Diseñado para sentirse invisible.",
      desc: "Un dedo, una pantalla, un nivel más.",
      placeholder: "Captura",
    },
    faq: {
      eyebrow: "Preguntas frecuentes",
      title: "Respondemos rápido.",
      items: [
        { q: "¿CTRL es una app educativa?", a: "No. Es un juego de puzzles inspirado en la lógica de programación." },
        { q: "¿Necesito una cuenta?", a: "No. No hace falta registrarse." },
        { q: "¿Funciona offline?", a: "Sí. Está diseñado para funcionar completamente sin conexión." },
        { q: "¿Recopila mis datos?", a: "No se requieren cuentas personales y el progreso queda local en tu dispositivo." },
        { q: "¿CTRL es gratis?", a: "Sí. Puedes descargar CTRL gratis." },
      ],
    },
    support: {
      eyebrow: "Apoya CTRL",
      title: "Gratis para jugar. Tuyo para apoyar.",
      desc: "CTRL se disfruta gratis. Si quieres apoyar su desarrollo, podrán habilitarse donaciones opcionales. Son voluntarias, no afectan la experiencia y no son obligatorias.",
      cta: "Apoyar el proyecto",
    },
    footer: {
      tagline: "Puzzles para devs. Cero fricción.",
      product: "Producto",
      legal: "Legal",
      appStore: "App Store",
      googlePlay: "Google Play",
      privacy: "Política de privacidad",
      terms: "Términos de uso",
      donations: "Donaciones y apoyo",
      contact: "Contacto",
      rights: "© CTRL. Todos los derechos reservados.",
    },
    legal: {
      back: "Volver al inicio",
      lastUpdated: "Última actualización",
      privacy: {
        title: "Política de privacidad",
        intro:
          "CTRL es un juego de puzzles para un solo jugador. Lo hemos diseñado para requerir la menor información personal posible.",
        sections: [
          { h: "Sin cuenta, sin login", p: "CTRL no requiere cuenta, correo ni contraseña. Puedes jugar nada más instalar la app." },
          { h: "Progreso local", p: "Tu progreso, ajustes y estadísticas se guardan localmente en tu dispositivo. No los sincronizamos ni los enviamos a ningún backend operado por nosotros." },
          { h: "Juego offline", p: "CTRL está diseñado para funcionar sin conexión. No se necesita internet para jugar y el juego principal no transmite datos por la red." },
          { h: "Publicidad (Google AdMob)", p: "CTRL puede mostrar anuncios ocasionales a través de Google AdMob. AdMob puede recopilar identificadores del dispositivo y señales de uso según la política de privacidad de Google. Puedes revisar y restablecer estos identificadores desde los ajustes de tu dispositivo." },
          { h: "Enlaces externos", p: "CTRL puede enlazar a destinos externos como App Store o Google Play. No somos responsables de las prácticas de privacidad de terceros." },
          { h: "Menores", p: "CTRL es apto para todos los públicos y no recopila intencionalmente información personal de menores." },
          { h: "Cambios", p: "Esta política puede actualizarse a medida que la app evoluciona. La versión vigente siempre estará disponible en esta página." },
          { h: "Contacto", p: "Si tienes dudas sobre privacidad, escríbenos desde el enlace de contacto del pie de página." },
        ],
      },
      terms: {
        title: "Términos de uso",
        intro: "Al instalar o usar CTRL, aceptas los siguientes términos.",
        sections: [
          { h: "Licencia", p: "CTRL te concede una licencia limitada, personal, no exclusiva e intransferible para instalar y jugar en los dispositivos que poseas o controles, con fines personales no comerciales." },
          { h: "Restricciones", p: "No puedes redistribuir, sublicenciar, hacer ingeniería inversa, descompilar o intentar extraer el código o contenido del juego, salvo cuando la ley lo permita expresamente." },
          { h: "Disponibilidad", p: "CTRL se ofrece tal cual y según disponibilidad. No garantizamos tiempo de actividad, compatibilidad con cualquier dispositivo ni la disponibilidad continua del juego o de niveles concretos." },
          { h: "Descargo de responsabilidad", p: "En la máxima medida permitida por la ley, CTRL se ofrece sin garantías de ningún tipo, expresas o implícitas, incluidas las de comerciabilidad, idoneidad para un fin concreto y no infracción." },
          { h: "Cambios", p: "Estos términos pueden actualizarse en el futuro. El uso continuado de CTRL tras los cambios implica aceptar los términos revisados." },
        ],
      },
      donations: {
        title: "Política de donaciones y apoyo",
        intro: "CTRL es gratis. Las donaciones son completamente opcionales.",
        sections: [
          { h: "Voluntarias", p: "Cualquier donación a CTRL es totalmente voluntaria. No se requieren para descargar, instalar ni disfrutar del juego completo." },
          { h: "Sin ventajas", p: "Las donaciones no otorgan ninguna ventaja competitiva, no desbloquean funciones esenciales ni alteran la experiencia de juego." },
          { h: "Reembolsos", p: "Las donaciones no son reembolsables, salvo cuando la ley aplicable lo exija." },
          { h: "Destino", p: "Las donaciones ayudan a cubrir el mantenimiento, el desarrollo continuo y el contenido nuevo de CTRL." },
        ],
      },
    },
  },
};

type Dict = (typeof translations)["en"];

type I18nContextValue = {
  lang: Lang;
  setLang: (l: Lang) => void;
  t: Dict;
};

const I18nContext = createContext<I18nContextValue | null>(null);

const STORAGE_KEY = "ctrl.lang";

function detectLang(): Lang {
  if (typeof window === "undefined") return "en";
  const stored = window.localStorage.getItem(STORAGE_KEY) as Lang | null;
  if (stored === "en" || stored === "es") return stored;
  const nav = window.navigator.language?.toLowerCase() ?? "";
  return nav.startsWith("es") ? "es" : "en";
}

export function I18nProvider({ children }: { children: ReactNode }) {
  const [lang, setLangState] = useState<Lang>("en");

  useEffect(() => {
    setLangState(detectLang());
  }, []);

  useEffect(() => {
    if (typeof document !== "undefined") {
      document.documentElement.lang = lang;
    }
  }, [lang]);

  const setLang = (l: Lang) => {
    setLangState(l);
    if (typeof window !== "undefined") {
      window.localStorage.setItem(STORAGE_KEY, l);
    }
  };

  return (
    <I18nContext.Provider value={{ lang, setLang, t: translations[lang] }}>
      {children}
    </I18nContext.Provider>
  );
}

export function useI18n() {
  const ctx = useContext(I18nContext);
  if (!ctx) throw new Error("useI18n must be used within I18nProvider");
  return ctx;
}