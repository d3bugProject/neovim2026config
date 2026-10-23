-- Plugin : bufferline.nvim (Onglets / Tabs modernes en haut)
-- Affiche chaque fichier ouvert comme un onglet (tab) style VS Code / IDE

return {
  "akinsho/bufferline.nvim",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    return {
      options = {
        mode = "buffers", -- Affiche les fichiers ouverts en onglets
        style_preset = require("bufferline").style_preset.default,
        themable = true,
        separator_style = "slant", -- Style moderne biseauté
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        color_icons = true,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Explorateur",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    }
  end,
}

