import type { ImportProps, PaginationProps, StatsProps, UserProps } from "./index"

export type DashboardPageProps = {
  stats: StatsProps
  users: UserProps[]
  user_filters: { query: string }
  user_pagination: PaginationProps
  active_import: ImportProps | null
}

export type UserPageProps = { user: UserProps }
