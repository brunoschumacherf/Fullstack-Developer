import { router } from "@inertiajs/react"
import { useEffect, useState, type FormEvent } from "react"
import { useT } from "../../i18n"

type UserSearchProps = { query: string }

export default function UserSearch({ query }: UserSearchProps) {
  const t = useT()
  const [value, setValue] = useState(query)
  useEffect(() => setValue(query), [query])

  const search = (event: FormEvent) => {
    event.preventDefault()
    router.get("/admin/dashboard", value.trim() ? { query: value.trim() } : {}, {
      preserveState: true, replace: true, only: ["users", "user_filters", "user_pagination"],
    })
  }

  return (
    <form onSubmit={search} className="flex w-full gap-2 sm:max-w-md" role="search">
      <input type="search" aria-label={t("dashboard.search_label")} value={value} onChange={event => setValue(event.target.value)}
        placeholder={t("dashboard.search_placeholder")}
        className="min-w-0 flex-1 rounded-lg border border-slate-300 px-3 py-2 text-sm shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-200" />
      <button type="submit" className="rounded-lg bg-slate-900 px-4 py-2 text-sm font-semibold text-white hover:bg-slate-800">
        {t("dashboard.search")}
      </button>
    </form>
  )
}
