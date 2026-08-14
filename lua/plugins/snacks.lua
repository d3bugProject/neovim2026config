-- Plugin : snacks.nvim (Picker fuzzy - recherche fichiers & texte)
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

    -- Fonctionnalités désactivées (légèreté)
    dashboard    = { enabled = false },
    indent       = { enabled = false },
    input        = { enabled = false },
    notifier     = { enabled = false },
    scroll       = { enabled = false },
    statuscolumn = { enabled = false },
    words        = { enabled = false },
  },
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
