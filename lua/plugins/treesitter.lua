-- Plugin : nvim-treesitter (Analyseur syntaxique universel & rapide)

vim.env.CC = "gcc"

return {
  "nvim-treesitter/nvim-treesitter",
  version = "v0.9.3", -- Version stable avec l'API configs (TSInstall, TSBufInfo etc.)
  build = ":TSUpdate",
  lazy = false,
  priority = 1000,
  opts = {
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
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
  end,
}
