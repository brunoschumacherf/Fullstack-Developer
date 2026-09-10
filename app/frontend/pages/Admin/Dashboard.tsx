import { Link, router, useForm } from "@inertiajs/react"
import { useEffect, useState, type FormEvent } from "react"
import consumer from "../../channels/consumer"
import { useT } from "../../i18n"
import type { ImportProps, StatsProps, UserProps } from "../../types"

type Props = {
  stats: StatsProps
  users: UserProps[]
  active_import: ImportProps | null
}

export default function Dashboard({ stats, users, active_import }: Props) {
  const t = useT()
  const [liveStats, setLiveStats] = useState(stats)
  const [importState, setImportState] = useState<ImportProps | null>(active_import)
  const { setData, post, processing } = useForm({ file: null as File | null })

  useEffect(() => {
    setLiveStats(stats)
  }, [stats])

  useEffect(() => {
    const subscription = consumer.subscriptions.create("DashboardChannel", {
      received(payload: StatsProps) {
        setLiveStats(payload)
      },
    })

    return () => subscription.unsubscribe()
  }, [])

  useEffect(() => {
    if (!importState?.id || importState.status === "completed" || importState.status === "failed") return

    const subscription = consumer.subscriptions.create(
      { channel: "ImportProgressChannel", id: importState.id },
      {
        received(payload: ImportProps) {
          setImportState(payload)
          if (payload.status === "completed" || payload.status === "failed") {
            router.reload({ only: ["users", "stats", "active_import"] })
          }
        },
      },
    )

    return () => subscription.unsubscribe()
  }, [importState?.id, importState?.status])

  const submitImport = (event: FormEvent) => {
    event.preventDefault()
    post("/admin/user_imports", { forceFormData: true })
  }

  const toggleRole = (user: UserProps) => {
    const role = user.role === "admin" ? "member" : "admin"
    router.patch(`/admin/users/${user.id}`, { user: { role } })
  }

  const deleteUser = (user: UserProps) => {
    if (confirm(t("dashboard.delete_confirm", { name: user.full_name }))) {
      router.delete(`/admin/users/${user.id}`)
    }
  }

  const importStatusLabel = (status: string) => t(`import_status.${status}`)

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

      <section className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
        <h2 className="text-lg font-semibold text-slate-900">{t("dashboard.import_title")}</h2>
        <p className="mt-1 text-sm text-slate-500">{t("dashboard.import_help")}</p>
        <form onSubmit={submitImport} className="mt-4 flex flex-col gap-3 sm:flex-row sm:items-center">
          <input
            type="file"
            accept=".csv,.xlsx"
            required
            onChange={(event) => setData("file", event.target.files?.[0] ?? null)}
            className="block w-full text-sm text-slate-500 file:mr-4 file:rounded-lg file:border-0 file:bg-indigo-50 file:px-4 file:py-2 file:font-semibold file:text-indigo-700 hover:file:bg-indigo-100"
          />
          <button
            type="submit"
            disabled={processing}
            className="rounded-lg bg-slate-900 px-4 py-2.5 text-sm font-semibold text-white hover:bg-slate-800 disabled:opacity-50"
          >
            {processing ? t("dashboard.uploading") : t("dashboard.start_import")}
          </button>
        </form>

        {importState && (
          <div className="mt-5 rounded-xl bg-slate-50 p-4">
            <div className="mb-2 flex items-center justify-between text-sm">
              <span className="font-medium text-slate-700">{t("dashboard.status", { status: importStatusLabel(importState.status) })}</span>
              <span className="text-slate-500">{importState.percentage}%</span>
            </div>
            <div className="h-2 overflow-hidden rounded-full bg-slate-200">
              <div className="h-full rounded-full bg-indigo-600 transition-all" style={{ width: `${importState.percentage}%` }} />
            </div>
            <p className="mt-2 text-xs text-slate-500">
              {t("dashboard.progress", {
                processed: importState.processed,
                total: importState.total,
                successful: importState.successful,
                failed: importState.failed,
              })}
            </p>
            {importState.errors?.length > 0 && (
              <ul className="mt-2 list-disc space-y-1 pl-5 text-xs text-rose-600">
                {importState.errors.slice(0, 8).map((message) => (
                  <li key={message}>{message}</li>
                ))}
              </ul>
            )}
          </div>
        )}
      </section>

      <section className="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
        <div className="border-b border-slate-100 px-6 py-4">
          <h2 className="text-lg font-semibold text-slate-900">{t("dashboard.users")}</h2>
        </div>
        <div className="overflow-x-auto">
          <table className="min-w-full text-left text-sm">
            <thead className="bg-slate-50 text-xs uppercase tracking-wide text-slate-500">
              <tr>
                <th className="px-6 py-3">{t("dashboard.user")}</th>
                <th className="px-6 py-3">{t("dashboard.email")}</th>
                <th className="px-6 py-3">{t("dashboard.role")}</th>
                <th className="px-6 py-3 text-right">{t("dashboard.actions")}</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {users.map((user) => (
                <tr key={user.id} className="hover:bg-slate-50/70">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <img src={user.avatar_url} alt="" className="h-9 w-9 rounded-full object-cover" />
                      <span className="font-medium text-slate-900">{user.full_name}</span>
                    </div>
                  </td>
                  <td className="px-6 py-4 text-slate-600">{user.email_address}</td>
                  <td className="px-6 py-4">
                    <span className={`rounded-full px-2.5 py-1 text-xs font-semibold ${user.role === "admin" ? "bg-emerald-50 text-emerald-700" : "bg-sky-50 text-sky-700"}`}>
                      {t(`roles.${user.role}`)}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-right">
                    <div className="flex justify-end gap-2">
                      <Link href={`/admin/users/${user.id}/edit`} className="rounded-md border border-slate-200 px-3 py-1.5 text-xs text-slate-700 hover:bg-slate-50">
                        {t("dashboard.edit")}
                      </Link>
                      <button type="button" onClick={() => toggleRole(user)} className="rounded-md border border-indigo-200 px-3 py-1.5 text-xs text-indigo-700 hover:bg-indigo-50">
                        {t("dashboard.toggle_role")}
                      </button>
                      <button type="button" onClick={() => deleteUser(user)} className="rounded-md border border-rose-200 px-3 py-1.5 text-xs text-rose-700 hover:bg-rose-50">
                        {t("dashboard.delete")}
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
    </div>
  )
}

function StatCard({ label, value, accent }: { label: string; value: number; accent: string }) {
  return (
    <div className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
      <p className="text-sm font-medium text-slate-500">{label}</p>
      <p className={`mt-2 text-4xl font-extrabold ${accent}`}>{value}</p>
    </div>
  )
}
