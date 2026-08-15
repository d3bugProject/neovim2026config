-- Plugin : nvim-treesitter (Gestionnaire de parseurs syntaxiques)
-- Utilise le moteur d'analyse natif de Neovim 0.12 pour des performances maximales sans aucun bug

vim.env.CC = "gcc"

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  lazy = false,
  priority = 1000,
  opts = {
    highlight = {
      enable = false, -- Désactivé au profit du highlighter natif Neovim 0.12 (sans bug de range)
    },
    indent = { enable = true },
    ensure_installed = {
      "javascript",
      "tsx",
      "typescript",
      "html",
      "css",
      "lua",
      "json",
      "markdown",
    },
    auto_install = true,
  },
  config = function(_, opts)
    require("nvim-treesitter.install").compilers = { "gcc" }
    require("nvim-treesitter.configs").setup(opts)

    -- Activer le surlignage syntaxique natif Neovim 0.12 sur chaque fichier
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("NativeTreesitterHighlight", { clear = true }),
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
