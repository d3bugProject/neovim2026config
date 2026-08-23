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
        ls.setup({
          region_check_events = "CursorMoved,CursorHold,InsertLeave",
          delete_check_events = "TextChanged,InsertLeave",
        })
        require("luasnip.loaders.from_vscode").lazy_load()

        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node
        local f = ls.function_node
        local uv = vim.uv or vim.loop

        -- 1. Manually defined React snippets
        local snippet_cn = s("cn", {
          t("className={`"),
          i(1),
          t("`}"),
        })

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

        local snippet_ust = s("ust", {
          t("const ["),
          i(1, "state"),
          t(", set"),
          i(2, "State"),
          t("] = useState("),
          i(3),
          t(");"),
        })

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

        -- 2. Custom JSON Snippets Loader Logic
        local snippet_imports = {}

        local function get_special_variable(var_name)
          local special_vars = {
            TM_FILENAME = function() return vim.fn.expand("%:t") end,
            TM_FILENAME_BASE = function()
              local filename = vim.fn.expand("%:t:r")
              return filename ~= "" and filename or "Component"
            end,
            TM_FILENAME_MAJ = function()
              local filename = vim.fn.expand("%:t:r")
              if filename == "" then return "Component" end
              return filename:sub(1, 1):upper() .. filename:sub(2)
            end,
            TM_FILENAME_PASCAL = function()
              local filename = vim.fn.expand("%:t:r")
              if filename == "" then return "Component" end
              local result = filename:gsub("[-_](%w)", function(c) return c:upper() end)
              return result:sub(1, 1):upper() .. result:sub(2)
            end,
            TM_FILENAME_CAMEL = function()
              local filename = vim.fn.expand("%:t:r")
              if filename == "" then return "component" end
              local result = filename:gsub("[-_](%w)", function(c) return c:upper() end)
              return result:sub(1, 1):lower() .. result:sub(2)
            end,
            TM_FILENAME_SNAKE = function()
              local filename = vim.fn.expand("%:t:r")
              if filename == "" then return "component" end
              return filename:gsub("(%u)", "_%1"):gsub("^_", ""):lower()
            end,
            TM_FILENAME_KEBAB = function()
              local filename = vim.fn.expand("%:t:r")
              if filename == "" then return "component" end
              return filename:gsub("(%u)", "-%1"):gsub("^-", ""):lower()
            end,
            TM_FILENAME_UPPER = function() return vim.fn.expand("%:t:r"):upper() end,
            TM_FILENAME_LOWER = function() return vim.fn.expand("%:t:r"):lower() end,
            TM_DIRECTORY = function() return vim.fn.expand("%:h:t") end,
            TM_FILEPATH = function() return vim.fn.expand("%:p") end,
            TM_FILENAME_DIRECTORY = function() return vim.fn.expand("%:h") end,
            CURRENT_YEAR = function() return os.date("%Y") end,
            CURRENT_YEAR_SHORT = function() return os.date("%y") end,
            CURRENT_MONTH = function() return os.date("%m") end,
            CURRENT_MONTH_NAME = function() return os.date("%B") end,
            CURRENT_MONTH_NAME_SHORT = function() return os.date("%b") end,
            CURRENT_DATE = function() return os.date("%d") end,
            CURRENT_DAY_NAME = function() return os.date("%A") end,
            CURRENT_DAY_NAME_SHORT = function() return os.date("%a") end,
            CURRENT_HOUR = function() return os.date("%H") end,
            CURRENT_MINUTE = function() return os.date("%M") end,
            CURRENT_SECOND = function() return os.date("%S") end,
            CURRENT_SECONDS_UNIX = function() return tostring(os.time()) end,
            WORKSPACE_NAME = function()
              local cwd = vim.fn.getcwd()
              return vim.fn.fnamemodify(cwd, ":t")
            end,
            WORKSPACE_FOLDER = function() return vim.fn.getcwd() end,
            UUID = function()
              local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
              return string.gsub(template, "[xy]", function(c)
                local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
                return string.format("%x", v)
              end)
            end,
            ["1maj"] = function(args)
              local val = args and args[1] or ""
              if not val or val == "" then return "" end
              return val:sub(1, 1):upper() .. val:sub(2)
            end,
          }
          return special_vars[var_name]
        end

        local function parse_snippet_body(body)
          local nodes = {}
          body = body:gsub("\\n", "\n")
          body = body:gsub("\\t", "\t")
          body = body:gsub('\\"', '"')
          body = body:gsub("\\'", "'")
          body = body:gsub("\\\\", "\\")

          local lines = vim.split(body, "\n", { plain = true })
          local placeholder_values = {}

          for line_idx, line in ipairs(lines) do
            local col = 1
            while col <= #line do
              local dollar_pos = line:find("%$", col)
              if not dollar_pos then
                if col <= #line then
                  table.insert(nodes, t(line:sub(col)))
                end
                break
              end

              if dollar_pos > col then
                table.insert(nodes, t(line:sub(col, dollar_pos - 1)))
              end

              local after_dollar = line:sub(dollar_pos + 1)
              local brace_content = after_dollar:match("^{([^}]*)}")

              if brace_content then
                local num, transform, default_val = brace_content:match("^(%d+)([a-zA-Z]+):(.*)$")
                if not num then
                  num, default_val = brace_content:match("^(%d+):(.*)$")
                end
                if not num then
                  num, transform = brace_content:match("^(%d+)([a-zA-Z]+)$")
                end

                if num and transform then
                  if transform == "maj" or transform == "cap" or transform == "capitalize" then
                    table.insert(nodes, f(function(args)
                      local val = args[1][1] or ""
                      if not val or val == "" then return default_val or "" end
                      return val:sub(1, 1):upper() .. val:sub(2)
                    end, { tonumber(num) }))
                  elseif transform == "upper" then
                    table.insert(nodes, f(function(args)
                      local val = args[1][1] or ""
                      return val:upper()
                    end, { tonumber(num) }))
                  elseif transform == "lower" then
                    table.insert(nodes, f(function(args)
                      local val = args[1][1] or ""
                      return val:lower()
                    end, { tonumber(num) }))
                  elseif transform == "snake" then
                    table.insert(nodes, f(function(args)
                      local val = args[1][1] or ""
                      return val:gsub("(%u)", "_%1"):gsub("^_", ""):lower()
                    end, { tonumber(num) }))
                  elseif transform == "camel" then
                    table.insert(nodes, f(function(args)
                      local val = args[1][1] or ""
                      return val:gsub("_(%w)", function(c) return c:upper() end):gsub("^%u", string.lower)
                    end, { tonumber(num) }))
                  elseif transform == "pascal" then
                    table.insert(nodes, f(function(args)
                      local val = args[1][1] or ""
                      local result = val:gsub("_(%w)", function(c) return c:upper() end)
                      return result:sub(1, 1):upper() .. result:sub(2)
                    end, { tonumber(num) }))
                  else
                    table.insert(nodes, i(tonumber(num), default_val or ""))
                  end
                elseif num and default_val ~= "" then
                  table.insert(nodes, i(tonumber(num), default_val))
                  placeholder_values[num] = default_val or ""
                elseif brace_content:match("^%d+$") then
                  table.insert(nodes, i(tonumber(brace_content)))
                  placeholder_values[brace_content] = ""
                else
                  local var_func = get_special_variable(brace_content)
                  if var_func then
                    table.insert(nodes, f(var_func, {}))
                  else
                    table.insert(nodes, t(brace_content))
                  end
                end
                col = dollar_pos + 1 + #brace_content + 2
              else
                local num = after_dollar:match("^(%d+)")
                if num then
                  table.insert(nodes, i(tonumber(num)))
                  placeholder_values[num] = ""
                  col = dollar_pos + 1 + #num
                else
                  table.insert(nodes, t("$"))
                  col = dollar_pos + 1
                end
              end
            end

            if line_idx < #lines then
              table.insert(nodes, t({ "", "" }))
            end
          end

          return nodes
        end

        local function load_snippets()
          local snippets = {}
          local snippet_path = vim.fn.stdpath("config") .. "/lua/snippets/"

          vim.fn.mkdir(snippet_path, "p")

          local handle = uv.fs_scandir(snippet_path)
          if not handle then
            return snippets
          end

          while true do
            local name = uv.fs_scandir_next(handle)
            if not name then break end

            if name:match("%.json$") then
              local file_path = snippet_path .. name
              local file = io.open(file_path, "r")

              if file then
                local content = file:read("*a")
                file:close()

                local ok, data = pcall(vim.json.decode, content)
                if ok and type(data) == "table" then
                  if data[1] then
                    for _, snip in ipairs(data) do
                      if snip.trigger and snip.snippet then
                        table.insert(snippets, snip)
                        if snip.import then
                          snippet_imports[snip.trigger] = snip.import
                        end
                      end
                    end
                  else
                    for key, snip in pairs(data) do
                      if snip.prefix and snip.body then
                        local body_text = type(snip.body) == "table" and table.concat(snip.body, "\n") or snip.body
                        local snippet_data = {
                          trigger = snip.prefix,
                          snippet = body_text,
                          import = snip.import,
                          description = snip.description,
                        }
                        table.insert(snippets, snippet_data)
                        if snip.import then
                          snippet_imports[snip.prefix] = snip.import
                        end
                      end
                    end
                  end
                end
              end
            end
          end
          return snippets
        end

        local all_snippets = load_snippets()

        local luasnip_snippets = {}
        for _, snip in ipairs(all_snippets) do
          local snippet_nodes = parse_snippet_body(snip.snippet)
          if snip.import and snip.import ~= "" then
            table.insert(snippet_nodes, 1, f(function()
              local bufnr = vim.api.nvim_get_current_buf()
              local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 5, false)
              for _, l in ipairs(lines) do
                if l == snip.import then return "" end
              end
              vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { snip.import })
              return ""
            end, {}))
          end
          table.insert(luasnip_snippets, s(snip.trigger, snippet_nodes))
        end

        ls.add_snippets("all", luasnip_snippets)

        vim.api.nvim_create_user_command("SnippetsReload", function()
          snippet_imports = {}
          all_snippets = load_snippets()
          luasnip_snippets = {}

          for _, snip in ipairs(all_snippets) do
            table.insert(luasnip_snippets, s(snip.trigger, parse_snippet_body(snip.snippet)))
            if snip.import then
              snippet_imports[snip.trigger] = snip.import
            end
          end

          ls.add_snippets("all", luasnip_snippets)
          print("Snippets rechargés : " .. #all_snippets .. " snippets")
        end, {})

        vim.api.nvim_create_user_command("SnippetsList", function()
          print("=== Snippets chargés ===")
          for i_snip, snip in ipairs(all_snippets) do
            local import_info = snip.import and (" -> " .. snip.import) or ""
            print(string.format("%d. %s: %s%s", i_snip, snip.trigger, snip.snippet:gsub("\n", "\\n"), import_info))
          end
        end, {})
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
