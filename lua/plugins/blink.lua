-- Plugin : blink.cmp (Moteur d'autocomplétion ultra-rapide avec binaire précompilé Windows)

return {
  "saghen/blink.cmp",
  lazy = false,
  version = "v0.11.0",
  dependencies = { "rafamadriz/friendly-snippets" },

  opts = {
    keymap = {
      preset = "default",
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },

    completion = {
      accept = {
        auto_brackets = { enabled = true },
      },
      menu = {
        auto_show = true,
        border = "rounded",
        draw = {
          columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 150,
        window = { border = "rounded" },
      },
      trigger = {
        show_on_keyword = true,
        show_on_trigger_character = true,
        show_on_insert_on_trigger_character = true,
        show_on_blocked_trigger_characters = {},
        show_on_x_blocked_trigger_characters = {},
      },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
}
