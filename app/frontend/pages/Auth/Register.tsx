import useUserEditor from "../../hooks/useUserEditor"
import { Link } from "@inertiajs/react"
import UserForm from "../../components/UserForm"
import { useT } from "../../i18n"

export default function Register() {
  const t = useT()
  const editor = useUserEditor({ url: "/register" })

  return (
    <div className="rounded-2xl border border-slate-200 bg-white p-8 shadow-sm">
      <h1 className="text-2xl font-bold text-slate-900">{t("register.title")}</h1>
      <p className="mt-1 text-sm text-slate-500">{t("register.subtitle")}</p>
      <div className="mt-6">
        <UserForm
          {...editor}
          submitLabel={t("forms.create_account")}
          requirePassword
        />
      </div>
      <p className="mt-6 text-center text-sm text-slate-600">
        {t("register.already")}{" "}
        <Link href="/login" className="font-medium text-indigo-600 hover:text-indigo-500">
          {t("register.sign_in")}
        </Link>
      </p>
    </div>
  )
}
