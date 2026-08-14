return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {
    settings = {
      expose_as_code_action = "all",
    },
    on_attach = function(client, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          -- Utiliser directement la fonction de typescript-tools
          require("typescript-tools.api").organize_imports(true)
        end,
      })
    end,
  },
}
