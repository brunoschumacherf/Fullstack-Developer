import { router, useForm, usePage } from "@inertiajs/react"
import type { FormEvent } from "react"
import UserForm from "../../components/UserForm"
import { useT } from "../../i18n"
import type { SharedProps, UserProps } from "../../types"

export default function Show({ user }: { user: UserProps }) {
  const { errors } = usePage<SharedProps>().props
  const t = useT()
  const { data, setData, post, processing } = useForm({
    _method: "patch",
    user: {
      full_name: user.full_name,
      email_address: user.email_address,
      password: "",
      password_confirmation: "",
      avatar_url: "",
      avatar: null as File | null,
    },
  })

  const submit = (event: FormEvent) => {
    event.preventDefault()
    post("/profile", { forceFormData: true })
  }

  const destroyProfile = () => {
    if (confirm(t("profile.delete_confirm"))) {
      router.delete("/profile")
    }
  }

  return (
    <div className="space-y-6">
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

      <section className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
        <h2 className="mb-4 text-lg font-semibold text-slate-900">{t("profile.edit_title")}</h2>
        <UserForm
          data={data.user}
          setData={(field, value) => setData(`user.${field}` as never, value as never)}
          onSubmit={submit}
          processing={processing}
          errors={errors ?? {}}
          submitLabel={t("forms.save_changes")}
        />
        <button type="button" onClick={destroyProfile} className="mt-6 text-sm text-rose-600 underline hover:text-rose-800">
          {t("profile.delete")}
        </button>
      </section>
    </div>
  )
}
