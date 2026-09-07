import { defineConfig } from "vite";

// Serve the Jekyll output without changing the GitHub Pages build.
export default defineConfig({
  root: "_site",
  publicDir: false,
  appType: "mpa",
  server: { host: "0.0.0.0", allowedHosts: ["terminal.local"] },
});
