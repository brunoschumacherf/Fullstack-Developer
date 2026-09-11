import "./application.css"

import { createInertiaApp } from "@inertiajs/react"
import { createElement } from "react"
import { createRoot, hydrateRoot } from "react-dom/client"
import resolvePage from "../lib/resolvePage"

createInertiaApp({
  resolve: resolvePage,
  setup({ el, App, props }) {
    const app = createElement(App, props)
    if (el.hasChildNodes()) {
      hydrateRoot(el, app)
    } else {
      createRoot(el).render(app)
    }
  },
})
