export type UserProps = {
  id: number
  full_name: string
  email_address: string
  role: "admin" | "member" | string
  avatar_url: string
}

export type StatsProps = {
  total_users: number
  role_counts: {
    admin?: number
    member?: number
  }
}

export type ImportProps = {
  id: number
  status: string
  total: number
  processed: number
  successful: number
  failed: number
  percentage: number
  errors: string[]
}

export type AuthProps = {
  user: UserProps | null
}

export type FlashProps = {
  notice?: string | null
  alert?: string | null
}

export type SharedProps = {
  auth: AuthProps
  flash: FlashProps
  i18n: Record<string, unknown>
  errors?: Record<string, string | string[]>
}
