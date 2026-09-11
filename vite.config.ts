import inertia from "@inertiajs/vite"
import { defineConfig } from "vite"
import RubyPlugin from "vite-plugin-ruby"
import react from "@vitejs/plugin-react"
import tailwindcss from "@tailwindcss/vite"

export default defineConfig({
  build: {
    sourcemap: false,
  },

  plugins: [
    RubyPlugin(),
    react(),
    tailwindcss(),
    inertia({
      ssr: {
        entry: "entrypoints/ssr.tsx",
        host: "127.0.0.1",
        port: 13714,
        cluster: true,
        sourcemap: false,
      },
    }),
  ],

  server: {
    host: "0.0.0.0",
    port: 3036,

    hmr: {
      host: "localhost",
      port: 3036,
    },
  },
})
