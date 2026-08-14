-- Plugin : neo-tree.nvim (Explorateur de fichiers - fenêtre flottante)
-- ✅ Optimisé : lazy load, watcher désactivé, toggle via commande native

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  lazy = true,
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  -- Keymap géré ICI (pas dans config) pour éviter le double déclenchement lazy
  keys = {
    {
      "<leader>e",
      "<cmd>Neotree float reveal toggle<CR>",
      desc = "Explorateur flottant (Neo-tree)",
      noremap = true,
      silent = true,
    },
  },
  opts = {
    close_if_last_window = false,

    -- Fenêtre flottante centrée
    window = {
      position = "float",
      popup = {
        size     = { height = "80%", width = "45%" },
        position = "50%",
        border   = "rounded",
      },
      mappings = {
        ["f"]             = "noop",
        ["<space>"]       = { "toggle_node", nowait = false },
        ["<2-LeftMouse>"] = "open",
        ["<cr>"] = function(state)
          local node = state.tree:get_node()
          if node.type == "file" then
            state.commands.open(state)
            vim.cmd("Neotree close")
          else
            state.commands.toggle_node(state)
          end
        end,
        ["o"]  = { "toggle_node", nowait = false },
        ["<esc>"] = "cancel",
        ["P"]  = { "toggle_preview", config = { use_float = true, use_image_nvim = false } },
        ["l"]  = "focus_preview",
        ["S"]  = "open_split",
        ["s"]  = "open_vsplit",
        ["t"]  = "open_tabnew",
        ["C"]  = "close_node",
        ["z"]  = "close_all_nodes",
        ["Z"]  = "expand_all_nodes",
        ["a"]  = { "add", config = { show_path = "none" } },
        ["A"]  = "add_directory",
        ["d"]  = "delete",
        ["r"]  = "rename",
        ["y"]  = "copy_to_clipboard",
        ["x"]  = "cut_to_clipboard",
        ["p"]  = "paste_from_clipboard",
        ["c"]  = "copy",
        ["m"]  = "move",
        ["q"]  = "close_window",
        ["R"]  = "refresh",
        ["?"]  = "show_help",
      },
    },

    filesystem = {
      filtered_items = {
        visible         = true,
        hide_dotfiles   = false,
        hide_gitignored = false,
        hide_by_name    = { "node_modules", ".git" },
        always_show     = {
          ".gitignore",
          ".env",
          ".eslintrc",
          ".prettierrc",
          ".nvmrc",
          ".babelrc",
        },
        never_show = {},
      },
      follow_current_file   = { enabled = true },
      group_empty_dirs       = false,
      hijack_netrw_behavior  = "disabled",
      -- ✅ Watcher désactivé → économie CPU/RAM
      use_libuv_file_watcher = false,
    },

    default_component_configs = {
      filesystem = { show_hidden_count = false },
    },
  },
}
