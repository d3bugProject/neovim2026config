-- Plugin : nvim-lspconfig (Configuration officielle des serveurs LSP pour React, JS, TS, HTML, CSS, Lua)

return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local mason_lspconfig = require("mason-lspconfig")

    mason_lspconfig.setup({
      ensure_installed = {
        "ts_ls",        -- Serveur TypeScript / JavaScript / JSX / TSX
        "html",         -- HTML
        "cssls",        -- CSS
        "tailwindcss",  -- Tailwind CSS
        "lua_ls",       -- Lua
      },
      automatic_installation = true,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Configuration propre des serveurs de langage via la nouvelle API vim.lsp.config (compatibilité Neovim moderne)
    vim.lsp.config("ts_ls", {
      cmd = { "typescript-language-server", "--stdio" },
      filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
      root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
      capabilities = capabilities,
    })

    vim.lsp.config("html", {
      capabilities = capabilities,
    })

    vim.lsp.config("cssls", {
      capabilities = capabilities,
    })

    vim.lsp.config("tailwindcss", {
      capabilities = capabilities,
    })

    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
        },
      },
    })

    -- Activer les serveurs
    vim.lsp.enable("ts_ls")
    vim.lsp.enable("html")
    vim.lsp.enable("cssls")
    vim.lsp.enable("tailwindcss")
    vim.lsp.enable("lua_ls")
  end,
}
