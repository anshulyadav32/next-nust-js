import type { Metadata } from "next";
import "./globals.css";
import AuthProvider from "./components/auth-provider";

export const metadata: Metadata = {
  title: "Next.js Auth App",
  description: "Authentication with NextAuth.js v5",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">
        <AuthProvider>{children}</AuthProvider>
      </body>
    </html>
  );
}
