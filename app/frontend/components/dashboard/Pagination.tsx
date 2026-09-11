import { Link } from "@inertiajs/react"
import { useT } from "../../i18n"
import type { PaginationProps } from "../../types"

type PaginationComponentProps = { pagination: PaginationProps; query: string }

export default function Pagination({ pagination, query }: PaginationComponentProps) {
  const t = useT()
  if (pagination.total_pages <= 1) return null
  const href = (page: number) => `/admin/dashboard?${new URLSearchParams({ ...(query ? { query } : {}), page: String(page) })}`
  const pages = Array.from({ length: pagination.total_pages }, (_, index) => index + 1)

  return (
    <nav aria-label={t("dashboard.pagination")} className="flex flex-wrap items-center justify-between gap-3 border-t border-slate-100 px-6 py-4">
      <p className="text-sm text-slate-500">{t("dashboard.results", { total: pagination.total })}</p>
      <div className="flex flex-wrap gap-1">
        {pages.map(page => (
          <Link key={page} href={href(page)} preserveState only={["users", "user_filters", "user_pagination"]}
            aria-current={page === pagination.page ? "page" : undefined}
            className={`rounded-md px-3 py-1.5 text-sm ${page === pagination.page ? "bg-indigo-600 text-white" : "border border-slate-200 text-slate-700 hover:bg-slate-50"}`}>
            {page}
          </Link>
        ))}
      </div>
    </nav>
  )
}
