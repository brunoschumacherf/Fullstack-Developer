import { Link, useForm, usePage } from "@inertiajs/react"
import type { FormEvent } from "react"
import { useT } from "../../i18n"
import type { SharedProps } from "../../types"

export default function Login() {
  const { errors } = usePage<SharedProps>().props
  const t = useT()
  const { data, setData, post, processing } = useForm({
    email_address: "",
    password: "",
  })

  const submit = (event: FormEvent) => {
    event.preventDefault()
    post("/login")
  }

  return (
    <div className="rounded-2xl border border-slate-200 bg-white p-8 shadow-sm">
      <h1 className="text-2xl font-bold text-slate-900">{t("login.title")}</h1>
      <p className="mt-1 text-sm text-slate-500">{t("login.subtitle")}</p>

      <form onSubmit={submit} className="mt-6 space-y-4" noValidate>
        <div>
          <label htmlFor="email_address" className="block text-sm font-medium text-slate-700">{t("login.email")}</label>
          <input
            id="email_address"
            type="email"
            required
            value={data.email_address}
            onChange={(event) => setData("email_address", event.target.value)}
            className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-200"
          />
        </div>
        <div>
          <label htmlFor="password" className="block text-sm font-medium text-slate-700">{t("login.password")}</label>
          <input
            id="password"
            type="password"
            required
            minLength={8}
            value={data.password}
            onChange={(event) => setData("password", event.target.value)}
            className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-200"
          />
        </div>
        {errors?.email_address && <p className="text-sm text-rose-600">{String(errors.email_address)}</p>}
        <button
          type="submit"
          disabled={processing}
          className="w-full rounded-lg bg-indigo-600 px-4 py-2.5 text-sm font-semibold text-white hover:bg-indigo-700 disabled:opacity-50"
        >
          {processing ? t("login.submitting") : t("login.submit")}
        </button>
      </form>

      <p className="mt-6 text-center text-sm text-slate-600">
        {t("login.new_here")}{" "}
        <Link href="/register" className="font-medium text-indigo-600 hover:text-indigo-500">
          {t("login.create_account")}
        </Link>
      </p>
    </div>
  )
}
