import { usePage } from "@inertiajs/react"
import type { SharedProps } from "../types"

export default function Flash() {
  const { flash } = usePage<SharedProps>().props

  if (!flash?.notice && !flash?.alert) return null

  return (
    <div className="mb-6 space-y-2">
      {flash.notice && (
        <div className="rounded-xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-800" role="status">
          {flash.notice}
        </div>
      )}
      {flash.alert && (
        <div className="rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-800" role="alert">
          {flash.alert}
        </div>
      )}
    </div>
  )
}
