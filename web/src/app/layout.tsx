import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "CTRL — Developer puzzles. Zero friction.",
  description:
    "CTRL is a minimalist puzzle game for developers. Short programming puzzles, one-handed play, offline first. Just one more level.",
  keywords:
    "developer puzzle game, programming puzzles, coding brain training, logic game for developers, programming challenges",
  openGraph: {
    title: "CTRL — Developer puzzles. Zero friction.",
    description:
      "Short programming puzzles. One-handed. Offline. Just one more level.",
    type: "website",
  },
  twitter: {
    title: "CTRL — Developer puzzles. Zero friction.",
    description: "Short programming puzzles. One-handed. Offline.",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
