-- Plugin : Oil.nvim (Édition de fichiers en mode buffer - outil secondaire)
-- Rôle : renommer/déplacer des fichiers comme dans un buffer texte
-- Raccourci : <leader>o (oil est secondaire, neo-tree est l'explorateur principal)

return {
  "stevearc/oil.nvim",
  lazy = true, -- Chargé uniquement à la demande
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    default_file_explorer = false, -- neo-tree gère l'exploration
    columns = { "icon" },
    keymaps = {
      ["g?"]  = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<C-r>"] = "actions.refresh",
      ["-"]   = "actions.parent",
      ["g."]  = "actions.toggle_hidden",
      ["q"]   = "actions.close",
    },
    use_default_keymaps = false,
    view_options = {
      show_hidden = false,
      is_always_hidden = function(name, _)
        return name == ".git" or name == "node_modules"
      end,
    },
    float = {
      padding     = 2,
      max_width   = 0.45,
      max_height  = 0.7,
      border      = "rounded",
      win_options = { winblend = 5 },
    },
    watch_for_changes = false, -- Pas de watcher CPU
  },
  keys = {
    { "<leader>o", "<cmd>lua require('oil').open_float()<CR>", desc = "Oil : édition buffer flottante" },
  },
}
