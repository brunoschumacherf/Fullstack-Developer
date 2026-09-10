import { Link, usePage } from "@inertiajs/react"
import type { PropsWithChildren } from "react"
import Flash from "../components/Flash"
import { useT } from "../i18n"
import type { SharedProps } from "../types"

export default function AppLayout({ children }: PropsWithChildren) {
  const { auth } = usePage<SharedProps>().props
  const t = useT()
  const isAdmin = auth.user?.role === "admin"

  return (
    <div className="min-h-screen">
      <header className="border-b border-slate-200 bg-white/90 backdrop-blur">
        <div className="mx-auto flex max-w-6xl flex-wrap items-center justify-between gap-4 px-4 py-4 sm:px-6">
          <Link href={isAdmin ? "/admin/dashboard" : "/profile"} className="text-lg font-semibold tracking-tight text-indigo-700">
            {t("brand")}
          </Link>
          <nav className="flex flex-wrap items-center gap-3 text-sm">
            {isAdmin && (
              <>
                <Link href="/admin/dashboard" className="rounded-lg px-3 py-2 text-slate-600 hover:bg-slate-100">
                  {t("nav.dashboard")}
                </Link>
                <Link href="/admin/users/new" className="rounded-lg px-3 py-2 text-slate-600 hover:bg-slate-100">
                  {t("nav.new_user")}
                </Link>
              </>
            )}
            <Link href="/profile" className="rounded-lg px-3 py-2 text-slate-600 hover:bg-slate-100">
              {t("nav.profile")}
            </Link>
            <Link href="/logout" method="delete" as="button" className="rounded-lg border border-rose-200 px-3 py-2 text-rose-600 hover:bg-rose-50">
              {t("nav.sign_out")}
            </Link>
          </nav>
        </div>
      </header>
      <main className="mx-auto max-w-6xl px-4 py-8 sm:px-6">
        <Flash />
        {children}
      </main>
    </div>
  )
}
