import { defineConfig } from "vitepress";

// https://vitepress.dev/reference/site-config
export default defineConfig({
  base: "/morty/",
  title: "Mortymer",
  description:
    "Standalone API definition for ruby frameworks based on dry.rb. Rails compatible from day 0 with a full Ruby flavored dependency injection engine.",
  markdown: {
    theme: "catppuccin-mocha",
  },
  themeConfig: {
    nav: [
      { text: "Guide", link: "/guide/introduction" },
      { text: "API", link: "/api/" },
      {
        text: "GitHub",
        link: "https://github.com/adriangs1996/morty",
      },
    ],

    sidebar: {
      "/guide/": [
        {
          text: "Getting Started",
          items: [
            { text: "Introduction", link: "/guide/introduction" },
            { text: "Quick Start", link: "/guide/quick-start" },
            { text: "Installation", link: "/guide/installation" },
          ],
        },
        {
          text: "Core Concepts",
          items: [
            { text: "API Metadata", link: "/guide/api-metadata" },
            { text: "Type System", link: "/guide/type-system" },
            {
              text: "Dependency Injection",
              link: "/guide/dependency-injection",
            },
            { text: "Error Handling", link: "/guide/error-handling" },
          ],
        },
        {
          text: "Rails Integration",
          items: [
            { text: "Setup", link: "/guide/rails-setup" },
            { text: "Routing", link: "/guide/routing" },
            { text: "Controllers", link: "/guide/controllers" },
            { text: "Testing", link: "/guide/testing" },
          ],
        },
        {
          text: "Advanced",
          items: [
            { text: "OpenAPI Generation", link: "/guide/openapi" },
            { text: "Custom Types", link: "/guide/custom-types" },
            { text: "Middleware", link: "/guide/middleware" },
            { text: "Configuration", link: "/guide/configuration" },
          ],
        },
      ],
    },

    socialLinks: [
      { icon: "github", link: "https://github.com/yourusername/morty" },
    ],

    footer: {
      message: "Released under the MIT License.",
      copyright: "Copyright © 2024-present",
    },
  },
});
