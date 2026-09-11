import type { FormFieldProps } from "../../types/forms"

export default function FormField({ id, label, error, className, ...input }: FormFieldProps) {
  const message = Array.isArray(error) ? error.join(", ") : error
  return (
    <div>
      <label htmlFor={id} className="block text-sm font-medium text-slate-700">{label}</label>
      <input
        {...input}
        id={id}
        aria-invalid={message ? true : undefined}
        aria-describedby={message ? `${id}-error` : undefined}
        className={className ?? "mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-200"}
      />
      {message && <p id={`${id}-error`} className="mt-1 text-sm text-rose-600">{message}</p>}
    </div>
  )
}
