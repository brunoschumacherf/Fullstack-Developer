import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    react(),
    tailwindcss(),
  ],
  server: {
    host: '0.0.0.0',
    hmr: {
      host: 'localhost',
      port: 5173,
    },
  },
})