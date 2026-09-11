import ProfileHeader from "../../components/profile/ProfileHeader"
import useUserEditor from "../../hooks/useUserEditor"
import type { UserPageProps } from "../../types/pages"
import { router } from "@inertiajs/react"
import UserForm from "../../components/UserForm"
import { useT } from "../../i18n"

export default function Show({ user }: UserPageProps) {
  const t = useT()
  const editor = useUserEditor({ user, url: "/profile" })

  const destroyProfile = () => {
    if (confirm(t("profile.delete_confirm"))) {
      router.delete("/profile")
    }
  }

  return (
    <div className="space-y-6">
      <ProfileHeader user={user} />

      <section className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
        <h2 className="mb-4 text-lg font-semibold text-slate-900">{t("profile.edit_title")}</h2>
        <UserForm
          {...editor}
          submitLabel={t("forms.save_changes")}
        />
        <button type="button" onClick={destroyProfile} className="mt-6 text-sm text-rose-600 underline hover:text-rose-800">
          {t("profile.delete")}
        </button>
      </section>
    </div>
  )
}
