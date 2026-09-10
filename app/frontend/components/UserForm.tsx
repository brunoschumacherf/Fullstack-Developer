import type { FormEvent } from "react"
import { useT } from "../i18n"

type FieldErrors = Record<string, string | string[] | undefined>

type Props = {
  data: {
    full_name: string
    email_address: string
    password: string
    password_confirmation: string
    role?: string
    avatar_url: string
    avatar: File | null
  }
  setData: (field: string, value: string | File | null) => void
  onSubmit: (event: FormEvent) => void
  processing: boolean
  errors: FieldErrors
  submitLabel: string
  showRole?: boolean
  requirePassword?: boolean
}

function errorText(value: string | string[] | undefined) {
  if (!value) return null
  return Array.isArray(value) ? value.join(", ") : value
}

export default function UserForm({
  data,
  setData,
  onSubmit,
  processing,
  errors,
  submitLabel,
  showRole = false,
  requirePassword = false,
}: Props) {
  const t = useT()

  return (
    <form onSubmit={onSubmit} className="space-y-4" noValidate>
      <div>
        <label htmlFor="full_name" className="block text-sm font-medium text-slate-700">{t("forms.full_name")}</label>
        <input
          id="full_name"
          required
          maxLength={100}
          value={data.full_name}
          onChange={(event) => setData("full_name", event.target.value)}
          className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-200"
        />
        {errorText(errors.full_name) && <p className="mt-1 text-sm text-rose-600">{errorText(errors.full_name)}</p>}
      </div>

      <div>
        <label htmlFor="email_address" className="block text-sm font-medium text-slate-700">{t("forms.email")}</label>
        <input
          id="email_address"
          type="email"
          required
          value={data.email_address}
          onChange={(event) => setData("email_address", event.target.value)}
          className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-200"
        />
        {errorText(errors.email_address) && <p className="mt-1 text-sm text-rose-600">{errorText(errors.email_address)}</p>}
      </div>

      <div className="grid gap-4 sm:grid-cols-2">
        <div>
          <label htmlFor="password" className="block text-sm font-medium text-slate-700">
            {requirePassword ? t("forms.password") : t("forms.password_optional")}
          </label>
          <input
            id="password"
            type="password"
            minLength={8}
            required={requirePassword}
            value={data.password}
            onChange={(event) => setData("password", event.target.value)}
            className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-200"
          />
          {errorText(errors.password) && <p className="mt-1 text-sm text-rose-600">{errorText(errors.password)}</p>}
        </div>
        <div>
          <label htmlFor="password_confirmation" className="block text-sm font-medium text-slate-700">{t("forms.password_confirmation")}</label>
          <input
            id="password_confirmation"
            type="password"
            minLength={8}
            required={requirePassword}
            value={data.password_confirmation}
            onChange={(event) => setData("password_confirmation", event.target.value)}
            className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-200"
          />
        </div>
      </div>

      {showRole && (
        <div>
          <label htmlFor="role" className="block text-sm font-medium text-slate-700">{t("forms.role")}</label>
          <select
            id="role"
            value={data.role}
            onChange={(event) => setData("role", event.target.value)}
            className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-200"
          >
            <option value="member">{t("roles.member")}</option>
            <option value="admin">{t("roles.admin")}</option>
          </select>
          {errorText(errors.role) && <p className="mt-1 text-sm text-rose-600">{errorText(errors.role)}</p>}
        </div>
      )}

      <div>
        <label htmlFor="avatar_url" className="block text-sm font-medium text-slate-700">{t("forms.avatar_url")}</label>
        <input
          id="avatar_url"
          type="url"
          placeholder="https://..."
          value={data.avatar_url}
          onChange={(event) => setData("avatar_url", event.target.value)}
          className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-200"
        />
        {errorText(errors.avatar_url) && <p className="mt-1 text-sm text-rose-600">{errorText(errors.avatar_url)}</p>}
      </div>

      <div>
        <label htmlFor="avatar" className="block text-sm font-medium text-slate-700">{t("forms.avatar_upload")}</label>
        <input
          id="avatar"
          type="file"
          accept="image/png,image/jpeg,image/gif,image/webp"
          onChange={(event) => setData("avatar", event.target.files?.[0] ?? null)}
          className="mt-1 block w-full text-sm text-slate-500 file:mr-4 file:rounded-lg file:border-0 file:bg-indigo-50 file:px-4 file:py-2 file:font-semibold file:text-indigo-700 hover:file:bg-indigo-100"
        />
        {errorText(errors.avatar) && <p className="mt-1 text-sm text-rose-600">{errorText(errors.avatar)}</p>}
      </div>

      <button
        type="submit"
        disabled={processing}
        className="w-full rounded-lg bg-indigo-600 px-4 py-2.5 text-sm font-semibold text-white hover:bg-indigo-700 disabled:opacity-50 sm:w-auto"
      >
        {processing ? t("forms.saving") : submitLabel}
      </button>
    </form>
  )
}
