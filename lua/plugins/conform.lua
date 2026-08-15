-- Plugin : conform.nvim (Formatage avec Prettier + Stylua)
-- Raccourci : <leader>f pour formater manuellement

return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufWritePre" }, -- Chargé seulement avant la sauvegarde
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      desc = "Formater le fichier (Prettier / Stylua)",
    },
  },
  opts = {
    -- Formateurs par type de fichier
    formatters_by_ft = {
      javascript      = { "prettier" },
      javascriptreact = { "prettier" },
      typescript      = { "prettier" },
      typescriptreact = { "prettier" },
      html            = { "prettier" },
      css             = { "prettier" },
      scss            = { "prettier" },
      json            = { "prettier" },
      jsonc           = { "prettier" },
      markdown        = { "prettier" },
      yaml            = { "prettier" },
      lua             = { "stylua" },
    },

    -- Format automatique à chaque sauvegarde
    format_on_save = {
      timeout_ms   = 2000,
      lsp_fallback = true,
    },

    -- Prettier : désactiver l'insertion automatique de {" "} dans le JSX
    formatters = {
      prettier = {
        prepend_args = {
          "--html-whitespace-sensitivity",
          "ignore",
          "--print-width",
          "120",
        },
        require_cwd = false,
      },
    },
  },
}
