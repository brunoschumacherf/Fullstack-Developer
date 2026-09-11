import { useT } from "../i18n"
import type { UserFormProps } from "../types/forms"
import FormField from "./forms/FormField"

export default function UserForm({ data, setData, onSubmit, processing, errors, submitLabel,
  showRole = false, requirePassword = false }: UserFormProps) {
  const t = useT()
  return (
    <form onSubmit={onSubmit} className="space-y-4" noValidate>
      <FormField id="full_name" label={t("forms.full_name")} required maxLength={100}
        value={data.full_name} onChange={event => setData("full_name", event.target.value)} error={errors.full_name} />
      <FormField id="email_address" label={t("forms.email")} type="email" required
        value={data.email_address} onChange={event => setData("email_address", event.target.value)} error={errors.email_address} />
      <div className="grid gap-4 sm:grid-cols-2">
        <FormField id="password" label={requirePassword ? t("forms.password") : t("forms.password_optional")}
          type="password" minLength={8} required={requirePassword} value={data.password}
          onChange={event => setData("password", event.target.value)} error={errors.password} />
        <FormField id="password_confirmation" label={t("forms.password_confirmation")}
          type="password" minLength={8} required={requirePassword} value={data.password_confirmation}
          onChange={event => setData("password_confirmation", event.target.value)} error={errors.password_confirmation} />
      </div>
      {showRole && (
        <div>
          <label htmlFor="role" className="block text-sm font-medium text-slate-700">{t("forms.role")}</label>
          <select id="role" value={data.role} onChange={event => setData("role", event.target.value)}
            className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-200">
            <option value="member">{t("roles.member")}</option>
            <option value="admin">{t("roles.admin")}</option>
          </select>
          {errors.role && <p className="mt-1 text-sm text-rose-600">{Array.isArray(errors.role) ? errors.role.join(", ") : errors.role}</p>}
        </div>
      )}
      <FormField id="avatar_url" label={t("forms.avatar_url")} type="url" placeholder="https://..."
        value={data.avatar_url} onChange={event => setData("avatar_url", event.target.value)} error={errors.avatar_url} />
      <FormField id="avatar" label={t("forms.avatar_upload")} type="file" accept="image/png,image/jpeg,image/gif,image/webp"
        onChange={event => setData("avatar", event.target.files?.[0] ?? null)} error={errors.avatar}
        className="mt-1 block w-full text-sm text-slate-500 file:mr-4 file:rounded-lg file:border-0 file:bg-indigo-50 file:px-4 file:py-2 file:font-semibold file:text-indigo-700 hover:file:bg-indigo-100" />
      <button type="submit" disabled={processing}
        className="w-full rounded-lg bg-indigo-600 px-4 py-2.5 text-sm font-semibold text-white hover:bg-indigo-700 disabled:opacity-50 sm:w-auto">
        {processing ? t("forms.saving") : submitLabel}
      </button>
    </form>
  )
}
