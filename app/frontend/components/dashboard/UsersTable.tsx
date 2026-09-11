import { Link, router } from "@inertiajs/react"
import { useT } from "../../i18n"
import type { UserProps } from "../../types"

type UsersTableProps = { users: UserProps[] }

export default function UsersTable({ users }: UsersTableProps) {
  const t = useT()
  const toggleRole = (user: UserProps) => {
    const role = user.role === "admin" ? "member" : "admin"
    router.patch(`/admin/users/${user.id}`, { user: { role } })
  }

  const deleteUser = (user: UserProps) => {
    if (confirm(t("dashboard.delete_confirm", { name: user.full_name }))) {
      router.delete(`/admin/users/${user.id}`)
    }
  }


  return (
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
  )
}
