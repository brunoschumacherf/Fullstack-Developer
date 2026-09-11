import { Link } from "@inertiajs/react"
import StatCard from "../../components/dashboard/StatCard"
import UsersTable from "../../components/dashboard/UsersTable"
import UserImportPanel from "../../components/dashboard/UserImportPanel"
import useDashboardStats from "../../hooks/useDashboardStats"
import { useT } from "../../i18n"
import type { DashboardPageProps } from "../../types/pages"

export default function Dashboard({ stats, users, active_import, user_filters, user_pagination }: DashboardPageProps) {
  const t = useT()
  const liveStats = useDashboardStats(stats)
  return (
    <div className="space-y-8">
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-3xl font-bold text-slate-900">{t("dashboard.title")}</h1>
          <p className="text-sm text-slate-500">{t("dashboard.subtitle")}</p>
        </div>
        <Link
          href="/admin/users/new"
          className="inline-flex items-center justify-center rounded-lg bg-indigo-600 px-4 py-2.5 text-sm font-semibold text-white hover:bg-indigo-700"
        >
          {t("dashboard.create_user")}
        </Link>
      </div>

      <div className="grid gap-4 sm:grid-cols-3">
        <StatCard label={t("dashboard.total_users")} value={liveStats.total_users} accent="text-indigo-600" />
        <StatCard label={t("dashboard.admins")} value={liveStats.role_counts?.admin ?? 0} accent="text-emerald-600" />
        <StatCard label={t("dashboard.members")} value={liveStats.role_counts?.member ?? 0} accent="text-sky-600" />
      </div>

      <UserImportPanel activeImport={active_import} />
      <UsersTable users={users} query={user_filters.query} pagination={user_pagination} />
    </div>
  )
}
