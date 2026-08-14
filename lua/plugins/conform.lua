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

    -- Prettier : utiliser le config local du projet s'il existe (.prettierrc etc.)
    formatters = {
      prettier = {
        -- Cherche le config prettier du projet, sinon utilise les defaults
        require_cwd = false,
      },
    },
  },
}
