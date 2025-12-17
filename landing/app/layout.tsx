import type { Metadata, Viewport } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "MindGarden — Забота о ментальном здоровье",
  description:
    "Приложение для ментального благополучия: медитации, дыхательные техники, CBT-упражнения и AI-собеседник. Начните заботиться о себе уже сегодня.",
  keywords: [
    "ментальное здоровье",
    "медитация",
    "осознанность",
    "mindfulness",
    "CBT",
    "когнитивно-поведенческая терапия",
    "дыхательные упражнения",
    "трекер настроения",
    "самопомощь",
    "психологическое здоровье",
  ],
  authors: [{ name: "MindGarden" }],
  creator: "MindGarden",
  publisher: "MindGarden",
  openGraph: {
    type: "website",
    locale: "ru_RU",
    url: "https://mindgarden.app",
    siteName: "MindGarden",
    title: "MindGarden — Забота о ментальном здоровье",
    description:
      "Приложение для ментального благополучия: медитации, дыхательные техники, CBT-упражнения и AI-собеседник.",
    images: [
      {
        url: "/og-image.png",
        width: 1200,
        height: 630,
        alt: "MindGarden",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title: "MindGarden — Забота о ментальном здоровье",
    description:
      "Приложение для ментального благополучия: медитации, дыхательные техники, CBT-упражнения и AI-собеседник.",
    images: ["/og-image.png"],
  },
  robots: {
    index: true,
    follow: true,
  },
  icons: {
    icon: "/favicon.ico",
    apple: "/apple-touch-icon.png",
  },
  manifest: "/manifest.json",
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  maximumScale: 1,
  themeColor: "#0C1810",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="ru" className="scroll-smooth">
      <body className="antialiased">{children}</body>
    </html>
  );
}
