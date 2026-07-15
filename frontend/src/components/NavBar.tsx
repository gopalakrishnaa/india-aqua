"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

const LINKS = [
  { href: "/", label: "Map" },
  { href: "/deficiency", label: "Deficiency" },
];

export function NavBar() {
  const pathname = usePathname();

  return (
    <header className="sticky top-0 z-30 border-b border-cyan-100 bg-white/80 backdrop-blur-md">
      <div className="mx-auto max-w-6xl px-4 h-16 flex items-center justify-between">
        <Link href="/" className="flex items-center gap-2.5 group">
          <span className="grid h-9 w-9 place-items-center rounded-xl bg-gradient-to-br from-cyan-500 to-sky-600 text-white shadow-sm shadow-cyan-500/30">
            <svg viewBox="0 0 24 24" className="h-5 w-5" fill="currentColor" aria-hidden>
              <path d="M12 2.5c3.6 4.2 6.5 7.7 6.5 11.2A6.5 6.5 0 0 1 12 20.2a6.5 6.5 0 0 1-6.5-6.5C5.5 10.2 8.4 6.7 12 2.5Z" />
            </svg>
          </span>
          <span className="flex flex-col leading-none">
            <span className="font-semibold tracking-tight text-slate-900">Ganga Aqua</span>
            <span className="text-[11px] text-cyan-700/80 mt-0.5">Water quality monitoring</span>
          </span>
        </Link>
        <nav className="flex gap-1">
          {LINKS.map((link) => {
            const active = pathname === link.href;
            return (
              <Link
                key={link.href}
                href={link.href}
                className={`px-3.5 py-2 rounded-lg text-sm font-medium transition-colors ${
                  active
                    ? "bg-cyan-600 text-white shadow-sm shadow-cyan-600/25"
                    : "text-slate-600 hover:text-cyan-700 hover:bg-cyan-50"
                }`}
              >
                {link.label}
              </Link>
            );
          })}
        </nav>
      </div>
    </header>
  );
}
