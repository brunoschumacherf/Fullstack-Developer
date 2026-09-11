import { useT } from "../../i18n"
import type { ImportProps } from "../../types"

type ImportProgressProps = { progress: ImportProps }

export default function ImportProgress({ progress }: ImportProgressProps) {
  const t = useT()
  const importStatusLabel = (status: string) => t(`import_status.${status}`)
  return (
          <div className="mt-5 rounded-xl bg-slate-50 p-4">
            <div className="mb-2 flex items-center justify-between text-sm">
              <span className="font-medium text-slate-700">{t("dashboard.status", { status: importStatusLabel(progress.status) })}</span>
              <span className="text-slate-500">{progress.percentage}%</span>
            </div>
            <div className="h-2 overflow-hidden rounded-full bg-slate-200">
              <div className="h-full rounded-full bg-indigo-600 transition-all" style={{ width: `${progress.percentage}%` }} />
            </div>
            <p className="mt-2 text-xs text-slate-500">
              {t("dashboard.progress", {
                processed: progress.processed,
                total: progress.total,
                successful: progress.successful,
                failed: progress.failed,
              })}
            </p>
            {progress.errors?.length > 0 && (
              <ul className="mt-2 list-disc space-y-1 pl-5 text-xs text-rose-600">
                {progress.errors.slice(0, 8).map((message) => (
                  <li key={message}>{message}</li>
                ))}
              </ul>
            )}
          </div>
  )
}
