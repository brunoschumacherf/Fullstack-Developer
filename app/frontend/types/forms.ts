import type { FormEvent, InputHTMLAttributes } from "react"
import type { UserProps } from "./index"

export type FieldErrors = Record<string, string | string[] | undefined>

export type UserFormData = {
  full_name: string
  email_address: string
  password: string
  password_confirmation: string
  role?: UserProps["role"]
  avatar_url: string
  avatar: File | null
}

export type SetUserField = <K extends keyof UserFormData>(field: K, value: UserFormData[K]) => void

export type UserFormProps = {
  data: UserFormData
  setData: SetUserField
  onSubmit: (event: FormEvent) => void
  processing: boolean
  errors: FieldErrors
  submitLabel: string
  showRole?: boolean
  requirePassword?: boolean
}

export type UserEditorOptions = {
  user?: UserProps
  url: string
  showRole?: boolean
}

export type FormFieldProps = InputHTMLAttributes<HTMLInputElement> & {
  id: string
  label: string
  error?: string | string[]
}
