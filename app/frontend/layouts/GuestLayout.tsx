import type { PropsWithChildren } from "react"
import Flash from "../components/Flash"
import { useT } from "../i18n"

export default function GuestLayout({ children }: PropsWithChildren) {
  const t = useT()

  return (
    <div className="flex min-h-screen items-center justify-center bg-gradient-to-br from-slate-100 via-indigo-50 to-slate-100 px-4 py-12">
      <div className="w-full max-w-lg">
        <p className="mb-6 text-center text-sm font-semibold uppercase tracking-[0.2em] text-indigo-600">
          {t("brand")}
        </p>
        <Flash />
        {children}
      </div>
    </div>
  )
}
