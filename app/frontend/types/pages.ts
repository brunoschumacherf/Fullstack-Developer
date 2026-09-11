import type { ImportProps, StatsProps, UserProps } from "./index"

export type DashboardPageProps = {
  stats: StatsProps
  users: UserProps[]
  active_import: ImportProps | null
}

export type UserPageProps = { user: UserProps }
