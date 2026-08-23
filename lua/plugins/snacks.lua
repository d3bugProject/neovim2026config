-- Plugin : snacks.nvim (Picker fuzzy & Dashboard d'accueil "AllBlue")
-- <leader><leader> → chercher un fichier dans le projet
-- <leader>s       → chercher un mot dans le projet (live grep)

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Fonctionnalités activées
    bigfile   = { enabled = true },  -- Désactive les plugins lourds sur les gros fichiers
    quickfile = { enabled = true },  -- Ouvre les fichiers plus vite
    picker    = {
      enabled = true,
      -- Fermer avec Esc en mode insert ou normal
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
          },
        },
      },
      -- Exclure les dossiers inutiles de la recherche
      sources = {
        files = {
          hidden          = false,
          follow_symlinks = false,
          exclude = {
            "node_modules",
            ".git",
            "dist",
            "build",
            ".next",
            "*.min.js",
            ".DS_Store",
          },
        },
      },
    },

    -- Dashboard stylé "AllBlue"
    dashboard = {
      enabled = true,
      row = nil,
      col = nil,
      pane_gap = 4,
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Chercher un fichier", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "s", desc = "Chercher du texte (grep)", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Fichiers récents", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "n", desc = "Nouveau fichier", action = ":ene | startinsert" },
          { icon = " ", key = "e", desc = "Explorateur Neo-tree", action = ":Neotree float reveal toggle" },
          { icon = " ", key = "c", desc = "Configuration Neovim", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = "󰒲 ", key = "l", desc = "Gestionnaire Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quitter Neovim", action = ":qa" },
        },
        header = [[
 █████╗ ██╗     ██╗     ██████╗ ██╗     ██╗   ██╗███████╗
██╔══██╗██║     ██║     ██╔══██╗██║     ██║   ██║██╔════╝
███████║██║     ██║     ██████╔╝██║     ██║   ██║█████╗  
██╔══██║██║     ██║     ██╔══██╗██║     ██║   ██║██╔══╝  
██║  ██║███████╗███████╗██████╔╝███████╗╚██████╔╝███████╗
╚═╝  ╚═╝╚══════╝╚══════╝╚═════╝ ╚══════╝ ╚═════╝ ╚══════╝]],
      },
      sections = {
        { section = "header" },
        {
          text = {
            { "🌊  A L L B L U E  ✦  D E V E L O P M E N T  🌊", hl = "SnacksDashboardSpecial" },
          },
          align = "center",
          padding = 1,
        },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },

    -- Fonctionnalités désactivées (légèreté)
    indent       = { enabled = false },
    input        = { enabled = false },
    notifier     = { enabled = false },
    scroll       = { enabled = false },
    statuscolumn = { enabled = false },
    words        = { enabled = false },
  },
  init = function()
    local augroup = vim.api.nvim_create_augroup("AllBlueDashboardGroup", { clear = true })

    -- Couleurs et mise en valeur du Dashboard AllBlue
    local function set_allblue_hl()
      vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#38bdf8", bold = true })
      vim.api.nvim_set_hl(0, "SnacksDashboardSpecial", { fg = "#818cf8", italic = true })
      vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = "#38bdf8", bold = true })
      vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = "#0ea5e9" })
      vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = "#94a3b8" })
      vim.api.nvim_set_hl(0, "SnacksDashboardFooter", { fg = "#64748b", italic = true })
    end

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = augroup,
      callback = set_allblue_hl,
    })
    set_allblue_hl()

    -- Ouvrir le Dashboard si Neovim est lancé sur un dossier (ex: `nvim .` ou `nvim <dossier>`)
    vim.api.nvim_create_autocmd("VimEnter", {
      group = augroup,
      nested = true,
      callback = function()
        if vim.fn.argc(-1) == 1 then
          local arg = vim.fn.argv(0)
          if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
            pcall(vim.cmd.cd, arg)
            local dir_buf = vim.api.nvim_get_current_buf()
            local new_buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_win_set_buf(0, new_buf)
            pcall(vim.api.nvim_buf_delete, dir_buf, { force = true })
            if Snacks and Snacks.dashboard then
              Snacks.dashboard.open({ buf = new_buf, win = vim.api.nvim_get_current_win() })
            end
          end
        end
      end,
    })
  end,
  keys = {
    -- <leader><leader> : chercher un fichier dans le dossier de travail
    {
      "<leader><leader>",
      function() Snacks.picker.files({ cwd = vim.fn.getcwd() }) end,
      desc = "Chercher un fichier (projet)",
    },
    -- <leader>s : chercher un mot dans le dossier de travail (live grep)
    {
      "<leader>s",
      function() Snacks.picker.grep({ cwd = vim.fn.getcwd() }) end,
      desc = "Chercher un mot dans le projet (grep)",
    },
  },
}
