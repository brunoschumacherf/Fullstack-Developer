import { Link, useForm, usePage } from "@inertiajs/react"
import type { FormEvent } from "react"
import UserForm from "../../components/UserForm"
import { useT } from "../../i18n"
import type { SharedProps } from "../../types"

export default function Register() {
  const { errors } = usePage<SharedProps>().props
  const t = useT()
  const { data, setData, post, processing } = useForm({
    user: {
      full_name: "",
      email_address: "",
      password: "",
      password_confirmation: "",
      avatar_url: "",
      avatar: null as File | null,
    },
  })

  const submit = (event: FormEvent) => {
    event.preventDefault()
    post("/register", { forceFormData: true })
  }

  return (
    <div className="rounded-2xl border border-slate-200 bg-white p-8 shadow-sm">
      <h1 className="text-2xl font-bold text-slate-900">{t("register.title")}</h1>
      <p className="mt-1 text-sm text-slate-500">{t("register.subtitle")}</p>
      <div className="mt-6">
        <UserForm
          data={data.user}
          setData={(field, value) => setData(`user.${field}` as never, value as never)}
          onSubmit={submit}
          processing={processing}
          errors={errors ?? {}}
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
