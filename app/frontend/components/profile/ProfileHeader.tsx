import { useT } from "../../i18n"
import type { UserPageProps } from "../../types/pages"

export default function ProfileHeader({ user }: UserPageProps) {
  const t = useT()
  return (
      <section className="flex flex-col gap-4 rounded-2xl border border-slate-200 bg-white p-6 shadow-sm sm:flex-row sm:items-center sm:justify-between">
        <div className="flex items-center gap-4">
          <img src={user.avatar_url} alt="" className="h-16 w-16 rounded-full object-cover ring-2 ring-indigo-100" />
          <div>
            <h1 className="text-2xl font-bold text-slate-900">{user.full_name}</h1>
            <p className="text-sm text-slate-500">
              {user.email_address} · <span className="font-semibold uppercase text-indigo-600">{t(`roles.${user.role}`)}</span>
            </p>
          </div>
        </div>
      </section>
  )
}
