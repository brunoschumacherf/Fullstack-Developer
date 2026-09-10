import { useForm, usePage } from "@inertiajs/react"
import type { FormEvent } from "react"
import UserForm from "../../../components/UserForm"
import { useT } from "../../../i18n"
import type { SharedProps, UserProps } from "../../../types"

export default function Edit({ user }: { user: UserProps }) {
  const { errors } = usePage<SharedProps>().props
  const t = useT()
  const { data, setData, post, processing } = useForm({
    _method: "patch",
    user: {
      full_name: user.full_name,
      email_address: user.email_address,
      password: "",
      password_confirmation: "",
      role: user.role,
      avatar_url: "",
      avatar: null as File | null,
    },
  })

  const submit = (event: FormEvent) => {
    event.preventDefault()
    post(`/admin/users/${user.id}`, { forceFormData: true })
  }

  return (
    <section className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
      <h1 className="mb-4 text-2xl font-bold text-slate-900">{t("users.edit_title", { name: user.full_name })}</h1>
      <UserForm
        data={data.user}
        setData={(field, value) => setData(`user.${field}` as never, value as never)}
        onSubmit={submit}
        processing={processing}
        errors={errors ?? {}}
        submitLabel={t("forms.save_user")}
        showRole
      />
    </section>
  )
}
