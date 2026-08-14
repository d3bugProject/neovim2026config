-- Plugin : Mason.nvim (Gestionnaire d'installation de serveurs LSP, Linter et Formatters)

return {
  -- Mason : installeur principal
  {
    "williamboman/mason.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed   = "✓",
          package_pending     = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Auto-install des formatters via Mason
  {
    "zapling/mason-conform.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim", "stevearc/conform.nvim" },
    opts = {
      -- Installe automatiquement prettier et stylua si absents
      ensure_installed = {
        "prettier",
        "stylua",
      },
    },
  },
}
