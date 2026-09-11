import useUserEditor from "../../../hooks/useUserEditor"
import UserForm from "../../../components/UserForm"
import { useT } from "../../../i18n"

export default function New() {
  const t = useT()
  const editor = useUserEditor({ url: "/admin/users", showRole: true })

  return (
    <section className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
      <h1 className="mb-4 text-2xl font-bold text-slate-900">{t("users.new_title")}</h1>
      <UserForm
        {...editor}
        submitLabel={t("forms.create_user")}
        showRole
        requirePassword
      />
    </section>
  )
}
