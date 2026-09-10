import tailwindcss from '@tailwindcss/vite'
import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'
import { VitePWA } from 'vite-plugin-pwa'

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    react(),
    tailwindcss(),
    VitePWA({
      registerType: 'autoUpdate',
      manifest: {
        name: 'Forge',
        short_name: 'Forge',
        description: 'Interactive coding education, built for actual learning.',
        theme_color: '#0E1210',
        background_color: '#0E1210',
        display: 'standalone',
        start_url: '/',
        icons: [
          {
            src: '/favicon.svg',
            sizes: 'any',
            type: 'image/svg+xml',
            purpose: 'any',
          },
          {
            src: '/icon-192.png',
            sizes: '192x192',
            type: 'image/png',
            purpose: 'any',
          },
          {
            src: '/icon-512.png',
            sizes: '512x512',
            type: 'image/png',
            purpose: 'any',
          },
          {
            src: '/icon-maskable-512.png',
            sizes: '512x512',
            type: 'image/png',
            purpose: 'maskable',
          },
        ],
      },
      workbox: {
        // Lesson content a student has already opened stays available on a
        // flaky connection or offline: cache-first with a background
        // revalidate, so a repeat visit is instant and self-heals once the
        // network is back. Workbox only intercepts GETs here, so writes
        // (POST/PATCH/DELETE) always hit the network.
        runtimeCaching: [
          {
            urlPattern: ({ url }) =>
              url.origin.includes('supabase.co') &&
              /\/rest\/v1\/(tracks|modules|lessons|sections|section_quizzes)(\?|$)/.test(
                url.pathname + url.search,
              ),
            handler: 'StaleWhileRevalidate',
            options: {
              cacheName: 'forge-lesson-content',
              expiration: { maxEntries: 300, maxAgeSeconds: 60 * 60 * 24 * 7 },
              cacheableResponse: { statuses: [0, 200] },
            },
          },
        ],
      },
    }),
  ],
})
