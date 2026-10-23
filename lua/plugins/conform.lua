-- Plugin : conform.nvim (Formatage avec Prettier + Stylua)
-- Raccourcis : 'f' ou '<leader>f' pour nettoyer les {" "} et formater

local function clean_and_format()
  local save_cursor = vim.fn.getpos(".")
  local old_query = vim.fn.getreg("/")

  -- Supprimer tous les {" "} ou {' '} ou {` `} du code
  vim.cmd([[%s/{\s*[`'"]\s*[`'"]\s*}//ge]])
  -- Supprimer les espaces résiduels en fin de ligne
  vim.cmd([[%s/\s\+$//e]])

  vim.fn.setreg("/", old_query)
  vim.fn.setpos(".", save_cursor)

  -- Formater avec Prettier / Stylua / LSP
  require("conform").format({ async = true, lsp_fallback = true })
end

return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufWritePre" }, -- Chargé seulement avant la sauvegarde
  keys = {
    {
      "f",
      clean_and_format,
      mode = "n",
      desc = "Nettoyer les {\" \"} et formater le code",
    },
    {
      "<leader>f",
      clean_and_format,
      mode = "n",
      desc = "Nettoyer les {\" \"} et formater le code",
    },
  },
  opts = {
    -- Formateurs par type de fichier
    formatters_by_ft = {
      javascript      = { "prettier" },
      javascriptreact = { "prettier" },
      typescript      = { "prettier" },
      typescriptreact = { "prettier" },
      html            = { "prettier" },
      css             = { "prettier" },
      scss            = { "prettier" },
      json            = { "prettier" },
      jsonc           = { "prettier" },
      markdown        = { "prettier" },
      yaml            = { "prettier" },
      lua             = { "stylua" },
    },

    -- Format automatique à chaque sauvegarde
    format_on_save = {
      timeout_ms   = 2000,
      lsp_fallback = false,
    },

    -- Prettier : désactiver l'insertion automatique de {" "} dans le JSX
    formatters = {
      prettier = {
        prepend_args = {
          "--html-whitespace-sensitivity",
          "ignore",
          "--print-width",
          "120",
        },
        require_cwd = false,
      },
    },
  },
}
