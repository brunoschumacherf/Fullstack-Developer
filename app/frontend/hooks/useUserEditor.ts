import { useForm, usePage } from "@inertiajs/react"
import type { FormEvent } from "react"
import type { SharedProps } from "../types"
import type { SetUserField, UserEditorOptions, UserFormData } from "../types/forms"

export default function useUserEditor({ user, url, showRole = false }: UserEditorOptions) {
  const { errors } = usePage<SharedProps>().props
  const initialUser: UserFormData = {
    full_name: user?.full_name ?? "",
    email_address: user?.email_address ?? "",
    password: "",
    password_confirmation: "",
    avatar_url: "",
    avatar: null,
    ...(showRole ? { role: user?.role ?? "member" } : {}),
  }
  const form = useForm({ _method: user ? "patch" : "post", user: initialUser })
  const setData: SetUserField = (field, value) => {
    form.setData(previous => ({ ...previous, user: { ...previous.user, [field]: value } }))
  }
  const onSubmit = (event: FormEvent) => {
    event.preventDefault()
    form.post(url, { forceFormData: true })
  }

  return { data: form.data.user, setData, onSubmit, processing: form.processing, errors: errors ?? {} }
}
