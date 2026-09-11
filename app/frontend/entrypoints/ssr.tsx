import { createInertiaApp } from "@inertiajs/react"
import { createElement } from "react"
import resolvePage from "../lib/resolvePage"

void createInertiaApp({
  resolve: resolvePage,
  setup: ({ App, props }) => createElement(App, props),
})
