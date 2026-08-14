return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      -- Formateur personnalisé pour nettoyer les imports
      clean_imports = {
        command = "awk",
        args = {
          "BEGIN { in_imports = 0; import_ended = 0 } "
            .. "/^[[:space:]]*import/ { in_imports = 1; print $0; next } "
            .. "/^[[:space:]]*$/ { if (in_imports && !import_ended) next; else print $0; next } "
            .. '{ if (in_imports && !import_ended) { print ""; import_ended = 1; in_imports = 0 } print $0 }',
        },
        stdin = true,
      },
    },
    formatters_by_ft = {
      javascript = { "clean_imports", "prettier" },
      javascriptreact = { "clean_imports", "prettier" },
      typescript = { "clean_imports", "prettier" },
      typescriptreact = { "clean_imports", "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      markdown = { "prettier" },
      lua = { "stylua" },
    },
    -- format_on_save = function(bufnr)
    --   -- Désactiver le formatage automatique si la variable globale est définie
    --   if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
    --     return
    --   end
    --   return { timeout_ms = 500, lsp_fallback = true }
    -- end,
  },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      desc = "Formater le fichier",
    },
    {
      "<leader>tf",
      function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        if vim.g.disable_autoformat then
          print("Format-on-save désactivé")
        else
          print("Format-on-save activé")
        end
      end,
      desc = "Toggle format-on-save",
    },
  },
}
