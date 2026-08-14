-- ======================================================
-- theme pour lualine
-- ======================================================
local custom_theme = {
  normal = {
    a = { fg = "#1a3029", bg = "#059669", gui = "bold" },
    b = { fg = "#1a3029", bg = "#059669" },
    c = { fg = "#fff", bg = "#0f172a", gui = "bold" },
    z = { fg = "#230a0aff", bg = "#831843", gui = "bold" },
  },
  insert = {
    a = { fg = "#fff", bg = "#dc2626", gui = "bold" },
    b = { fg = "#fff", bg = "#dc2626" },
    c = { fg = "#fff", bg = "#0f172a", gui = "bold" },
    z = { fg = "#fff", bg = "#831843", gui = "bold" },
  },
  visual = {
    a = { fg = "#fff", bg = "#3b82f6", gui = "bold" },
    b = { fg = "#fff", bg = "#3b82f6" },
    c = { fg = "#fff", bg = "#0f172a", gui = "bold" },
    z = { fg = "#fff", bg = "#831843", gui = "bold" },
  },
  replace = {
    a = { fg = "#fff", bg = "#eab308", gui = "bold" },
    b = { fg = "#fff", bg = "#eab308" },
    c = { fg = "#fff", bg = "#0f172a", gui = "bold" },
    z = { fg = "#fff", bg = "#831843", gui = "bold" },
  },
  inactive = {
    a = { fg = "#fff", bg = "#0f172a", gui = "bold" },
    b = { fg = "#fff", bg = "#0f172a" },
    c = { fg = "#fff", bg = "#0f172a", gui = "bold" },
    z = { fg = "#fff", bg = "#831843", gui = "bold" },
  },
}

return {
  -- ======================================================
  -- INTERFACE - BARRE DE STATUT LUALINE
  -- ======================================================

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = custom_theme,
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          globalstatus = true,
          disabled_filetypes = {},
        },
        sections = {
          lualine_a = {
            {
              function()
                return "🚀  init5"
              end,
              padding = { left = 1, right = 1 },
              draw_empty = true,
            },
          },
          lualine_b = {
            {
              "mode",
              fmt = function(str)
                return str:upper()
              end,
              padding = { left = 1, right = 1 },
            },
          },
          lualine_c = {
            {
              "filename",
              path = 1,
              fmt = function(name)
                return "  " .. name .. "  "
              end,
              color = { fg = "#fff", bg = "#0f172a", gui = "bold" },
              padding = { left = 1, right = 1 },
            },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {
            {
              function()
                local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
                local branch = handle:read("*a"):gsub("%s+", "")
                handle:close()
                if branch == "" then
                  return "🌱 Pas de branche"
                else
                  return "🌿 " .. branch
                end
              end,
              color = { fg = "#fff", bg = "#831843", gui = "bold" },
              padding = { left = 1, right = 1 },
            },
            {
              function()
                -- Ajouts
                local added = tonumber(vim.fn.system("git diff --numstat 2>/dev/null | awk '{s+=$1} END {print s}'"))
                  or 0
                -- Modifications (approximation : lignes modifiées)
                local changed = tonumber(vim.fn.system("git diff --numstat 2>/dev/null | awk '{s+=$2} END {print s}'"))
                  or 0
                -- Suppressions
                local removed = tonumber(vim.fn.system("git diff --numstat 2>/dev/null | awk '{s+=$3} END {print s}'"))
                  or 0
                -- Fichiers non suivis
                local untracked = tonumber(vim.fn.system("git ls-files --others --exclude-standard | wc -l")) or 0
                local parts = {}
                if added > 0 then
                  table.insert(parts, "➕" .. added)
                end
                if changed > 0 then
                  table.insert(parts, "📝" .. changed)
                end
                if removed > 0 then
                  table.insert(parts, "➖" .. removed)
                end
                if untracked > 0 then
                  table.insert(parts, "❓" .. untracked)
                end
                return table.concat(parts, "  ")
              end,
              color = { fg = "#fff", bg = "#831843", gui = "bold" },
              padding = { left = 1, right = 1 },
              on_click = function()
                vim.notify(
                  "🌿 Branche : nom de la branche courante\n"
                    .. "➕ : lignes ajoutées (non commit)\n"
                    .. "📝 : lignes modifiées (non commit)\n"
                    .. "➖ : lignes supprimées (non commit)\n"
                    .. "❓ : fichiers non suivis (untracked, pas encore ajoutés à git)",
                  vim.log.levels.INFO,
                  { title = "Explication des statuts git" }
                )
              end,
            },
            {
              function()
                local gitsigns = vim.b.gitsigns_status_dict or {}
                local added = gitsigns.added or 0
                local changed = gitsigns.changed or 0
                local removed = gitsigns.removed or 0
                local ahead = gitsigns.ahead or 0
                local behind = gitsigns.behind or 0
                local parts = {}
                if added > 0 then
                  table.insert(parts, "➕" .. added)
                end
                if changed > 0 then
                  table.insert(parts, "📝" .. changed)
                end
                if removed > 0 then
                  table.insert(parts, "➖" .. removed)
                end
                if ahead > 0 then
                  table.insert(parts, "⬆️" .. ahead)
                end
                if behind > 0 then
                  table.insert(parts, "⬇️" .. behind)
                end
                return table.concat(parts, "  ")
              end,
              color = { fg = "#fff", bg = "#831843", gui = "bold" },
              padding = { left = 1, right = 1 },
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              "filename",
              color = { fg = "#fff", bg = "#0f172a", gui = "bold" },
            },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      })
    end,
  },
}
