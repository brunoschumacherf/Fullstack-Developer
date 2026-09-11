import useUserEditor from "../../../hooks/useUserEditor"
import type { UserPageProps } from "../../../types/pages"
import UserForm from "../../../components/UserForm"
import { useT } from "../../../i18n"

export default function Edit({ user }: UserPageProps) {
  const t = useT()
  const editor = useUserEditor({ user, url: `/admin/users/${user.id}`, showRole: true })

  return (
    <section className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
      <h1 className="mb-4 text-2xl font-bold text-slate-900">{t("users.edit_title", { name: user.full_name })}</h1>
      <UserForm
        {...editor}
        submitLabel={t("forms.save_user")}
        showRole
      />
    </section>
  )
}
