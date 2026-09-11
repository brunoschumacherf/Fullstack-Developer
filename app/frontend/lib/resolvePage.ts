import { createElement, type ComponentType, type ReactNode } from "react"
import AppLayout from "../layouts/AppLayout"
import GuestLayout from "../layouts/GuestLayout"

type InertiaPage = ComponentType & {
  layout?: (page: ReactNode) => ReactNode
}

type PageModule = {
  default: InertiaPage
}

const pages = import.meta.glob<PageModule>("../pages/**/*.tsx", { eager: true })
const guestPages = new Set(["Auth/Login", "Auth/Register"])

export default function resolvePage(name: string) {
  const page = pages[`../pages/${name}.tsx`]
  if (!page) throw new Error(`Missing Inertia page: ${name}`)

  page.default.layout ??= (pageNode: ReactNode) =>
    createElement(guestPages.has(name) ? GuestLayout : AppLayout, null, pageNode)

  return page
}
