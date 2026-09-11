import ImportProgress from "./ImportProgress"
import { useForm } from "@inertiajs/react"
import type { FormEvent } from "react"
import { useT } from "../../i18n"
import useImportProgress from "../../hooks/useImportProgress"
import type { ImportProps } from "../../types"

type UserImportPanelProps = { activeImport: ImportProps | null }

export default function UserImportPanel({ activeImport }: UserImportPanelProps) {
  const t = useT()
  const importState = useImportProgress(activeImport)
  const { setData, post, processing } = useForm({ file: null as File | null })
  const submitImport = (event: FormEvent) => {
    event.preventDefault()
    post("/admin/user_imports", { forceFormData: true })
  }
  return (
      <section className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
        <h2 className="text-lg font-semibold text-slate-900">{t("dashboard.import_title")}</h2>
        <p className="mt-1 text-sm text-slate-500">{t("dashboard.import_help")}</p>
        <form onSubmit={submitImport} className="mt-4 flex flex-col gap-3 sm:flex-row sm:items-center">
          <input
            aria-label={t("dashboard.import_title")}
            type="file"
            accept=".csv,.xlsx"
            required
            onChange={(event) => setData("file", event.target.files?.[0] ?? null)}
            className="block w-full text-sm text-slate-500 file:mr-4 file:rounded-lg file:border-0 file:bg-indigo-50 file:px-4 file:py-2 file:font-semibold file:text-indigo-700 hover:file:bg-indigo-100"
          />
          <button
            type="submit"
            disabled={processing}
            className="rounded-lg bg-slate-900 px-4 py-2.5 text-sm font-semibold text-white hover:bg-slate-800 disabled:opacity-50"
          >
            {processing ? t("dashboard.uploading") : t("dashboard.start_import")}
          </button>
        </form>

        {importState && (
          <ImportProgress progress={importState} />
        )}
      </section>

  )
}
