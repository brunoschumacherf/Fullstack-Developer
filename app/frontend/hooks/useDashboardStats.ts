import { useEffect, useState } from "react"
import consumer from "../channels/consumer"
import type { StatsProps } from "../types"

export default function useDashboardStats(stats: StatsProps) {
  const [liveStats, setLiveStats] = useState(stats)
  useEffect(() => setLiveStats(stats), [stats])
  useEffect(() => {
    const subscription = consumer.subscriptions.create("DashboardChannel", { received: setLiveStats })
    return () => subscription.unsubscribe()
  }, [])
  return liveStats
}
