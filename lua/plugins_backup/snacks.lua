if false then
  return {}
end
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    explorer = { enabled = false },
    indent = { enabled = false },
    scroll = { enabled = false },
    picker = {
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
          },
        },
      },
      sources = {
        files = {
          hidden = false, -- Pas de fichiers cachés
          follow_symlinks = false,
          -- Utiliser les patterns d'exclusion
          exclude = {
            ".DS_Store",
            "node_modules",
            ".git",
            "*.min.js",
            "dist",
            "build",
          },
        },
      },
    },
  },
}
