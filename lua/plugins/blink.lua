-- Plugin : blink.cmp (Moteur d'autocomplétion avec Copilot, LuaSnip & Snippets React)

return {
  "saghen/blink.cmp",
  lazy = false,
  version = "v0.11.0",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "dsznajder/vscode-es7-javascript-react-snippets",
    "zbirenbaum/copilot.lua",
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      config = function()
        local ls = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()

        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node

        -- Snippet cn -> className={`...`}
        local snippet_cn = s("cn", {
          t("className={`"),
          i(1),
          t("`}"),
        })

        -- Snippet useEffect (déclenché par 'ufe' ou 'useEffect')
        local snippet_ufe = s("ufe", {
          t("useEffect(() => {"),
          t({ "", "  " }),
          i(1),
          t({ "", "}, [" }),
          i(2),
          t("]);"),
        })

        local snippet_useeffect = s("useEffect", {
          t("useEffect(() => {"),
          t({ "", "  " }),
          i(1),
          t({ "", "}, [" }),
          i(2),
          t("]);"),
        })

        -- Snippet useState (déclenché par 'ust' ou 'useState')
        local snippet_ust = s("ust", {
          t("const ["),
          i(1, "state"),
          t(", set"),
          i(2, "State"),
          t("] = useState("),
          i(3),
          t(");"),
        })

        -- React Functional Component (rfc)
        local snippet_rfc = s("rfc", {
          t("function "),
          i(1, "App"),
          t("() {"),
          t({ "", "  return (" }),
          t({ "", "    <div>" }),
          t({ "", "      " }),
          i(2),
          t({ "", "    </div>" }),
          t({ "", "  );" }),
          t({ "", "}" }),
          t({ "", "", "export default " }),
          i(3, "App"),
          t(";"),
        })

        -- React Arrow Functional Component avec export (rafce)
        local snippet_rafce = s("rafce", {
          t("import React from 'react';"),
          t({ "", "", "const " }),
          i(1, "App"),
          t(" = () => {"),
          t({ "", "  return (" }),
          t({ "", "    <div>" }),
          t({ "", "      " }),
          i(2),
          t({ "", "    </div>" }),
          t({ "", "  );" }),
          t({ "", "};" }),
          t({ "", "", "export default " }),
          i(3, "App"),
          t(";"),
        })

        -- React Native Functional Export (rnfe)
        local snippet_rnfe = s("rnfe", {
          t("import { StyleSheet, Text, View } from 'react-native';"),
          t({ "", "import React from 'react';" }),
          t({ "", "", "const " }),
          i(1, "App"),
          t(" = () => {"),
          t({ "", "  return (" }),
          t({ "", "    <View>" }),
          t({ "", "      <Text>" }),
          i(2, "App"),
          t("</Text>"),
          t({ "", "    </View>" }),
          t({ "", "  );" }),
          t({ "", "};" }),
          t({ "", "", "export default " }),
          i(3, "App"),
          t(";"),
          t({ "", "", "const styles = StyleSheet.create({});" }),
        })

        -- React Native Component + StyleSheet (rnfs)
        local snippet_rnfs = s("rnfs", {
          t("import React from 'react';"),
          t({ "", "import { StyleSheet, Text, View } from 'react-native';" }),
          t({ "", "", "export default function " }),
          i(1, "App"),
          t("() {"),
          t({ "", "  return (" }),
          t({ "", "    <View style={styles.container}>" }),
          t({ "", "      <Text>" }),
          i(2, "App"),
          t("</Text>"),
          t({ "", "    </View>" }),
          t({ "", "  );" }),
          t({ "", "}" }),
          t({ "", "", "const styles = StyleSheet.create({" }),
          t({ "", "  container: {}," }),
          t({ "", "});" }),
        })

        local react_fts = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
        for _, ft in ipairs(react_fts) do
          ls.add_snippets(ft, {
            snippet_cn,
            snippet_ufe,
            snippet_useeffect,
            snippet_ust,
            snippet_rfc,
            snippet_rafce,
            snippet_rnfe,
            snippet_rnfs,
          })
        end
      end,
    },
  },

  opts = {
    -- Moteur de snippets robuste (LuaSnip) pour supporter 100% des snippets VSCode sans erreur de parsing
    snippets = { preset = "luasnip" },

    keymap = {
      preset = "default",
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<CR>"] = { "accept", "fallback" },
      -- Tab : défile dans le menu SI ouvert, SINON saute au placeholder suivant du snippet ($1 -> $2 -> $3)
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = {
        function()
          local ok, copilot = pcall(require, "copilot.suggestion")
          if ok and copilot.is_visible() then
            copilot.accept()
            return true
          end
        end,
        "select_prev",
        "snippet_backward",
        "fallback",
      },
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
          treesitter = {},
          columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 150,
        treesitter_highlighting = false, -- Empêche les erreurs Treesitter pendant le filtrage d'autocomplétion
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
      -- Uniquement le LSP, les chemins de fichiers et les snippets
      default = { "lsp", "path", "snippets" },
    },
  },
}
