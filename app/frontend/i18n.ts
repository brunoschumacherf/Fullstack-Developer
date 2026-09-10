import { usePage } from "@inertiajs/react"
import type { SharedProps } from "./types"

type Vars = Record<string, string | number>

function lookup(source: unknown, path: string): string {
  const value = path.split(".").reduce<unknown>((acc, key) => {
    if (acc && typeof acc === "object" && key in (acc as object)) {
      return (acc as Record<string, unknown>)[key]
    }
    return undefined
  }, source)

  return typeof value === "string" ? value : path
}

function interpolate(template: string, vars?: Vars) {
  if (!vars) return template
  return template.replace(/%\{(\w+)\}/g, (_, key) => String(vars[key] ?? ""))
}

export function useT() {
  const { i18n } = usePage<SharedProps>().props

  return (path: string, vars?: Vars) => interpolate(lookup(i18n, path), vars)
}
