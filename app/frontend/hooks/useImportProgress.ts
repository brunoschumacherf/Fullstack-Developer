import { router } from "@inertiajs/react"
import { useEffect, useState } from "react"
import consumer from "../channels/consumer"
import type { ImportProps } from "../types"

export default function useImportProgress(activeImport: ImportProps | null) {
  const [progress, setProgress] = useState(activeImport)
  useEffect(() => setProgress(activeImport), [activeImport])
  useEffect(() => {
    if (!progress || progress.status === "completed" || progress.status === "failed") return
    const subscription = consumer.subscriptions.create(
      { channel: "ImportProgressChannel", id: progress.id },
      {
        received(payload: ImportProps) {
          setProgress(payload)
          if (payload.status === "completed" || payload.status === "failed") {
            router.reload({ only: ["users", "stats", "active_import"] })
          }
        },
      },
    )
    return () => subscription.unsubscribe()
  }, [progress?.id, progress?.status])
  return progress
}
