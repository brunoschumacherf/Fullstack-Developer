import { createInertiaApp } from "@inertiajs/react"
import createServer from "@inertiajs/react/server"
import { createElement, type ReactNode } from "react"
import ReactDOMServer from "react-dom/server"
import AppLayout from "../layouts/AppLayout"
import GuestLayout from "../layouts/GuestLayout"

type PageModule = {
  default: React.ComponentType & {
    layout?: (page: ReactNode) => ReactNode
  }
}

const guestPages = new Set(["Auth/Login", "Auth/Register"])

createServer((page) =>
  createInertiaApp({
    page,
    render: ReactDOMServer.renderToString,
    resolve: (name) => {
      const pages = import.meta.glob<PageModule>("../pages/**/*.tsx", { eager: true })
      const pageModule = pages[`../pages/${name}.tsx`]
      if (!pageModule) {
        throw new Error(`Missing Inertia page: ${name}`)
      }

      pageModule.default.layout ??= (pageNode: ReactNode) =>
        createElement(guestPages.has(name) ? GuestLayout : AppLayout, null, pageNode)

      return pageModule
    },
    setup: ({ App, props }) => createElement(App, props),
  }),
)
