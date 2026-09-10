import "./application.css"

import { createInertiaApp } from "@inertiajs/react"
import { createElement, type ReactNode } from "react"
import { createRoot, hydrateRoot } from "react-dom/client"
import AppLayout from "../layouts/AppLayout"
import GuestLayout from "../layouts/GuestLayout"

type PageModule = {
  default: React.ComponentType & {
    layout?: (page: ReactNode) => ReactNode
  }
}

const guestPages = new Set(["Auth/Login", "Auth/Register"])

createInertiaApp({
  resolve: (name: string) => {
    const pages = import.meta.glob<PageModule>("../pages/**/*.tsx", { eager: true })
    const page = pages[`../pages/${name}.tsx`]
    if (!page) {
      throw new Error(`Missing Inertia page: ${name}`)
    }

    page.default.layout ??= (pageNode: ReactNode) =>
      createElement(guestPages.has(name) ? GuestLayout : AppLayout, null, pageNode)

    return page
  },
  setup({ el, App, props }) {
    const app = createElement(App, props)
    if (el.hasChildNodes()) {
      hydrateRoot(el, app)
    } else {
      createRoot(el).render(app)
    }
  },
})
