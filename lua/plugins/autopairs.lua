-- Plugin : nvim-autopairs (Fermeture automatique des paires : ( { [ " ' ` etc.)
-- nvim-ts-autotag gère les balises HTML/JSX, autopairs gère les caractères

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter", -- Chargé uniquement en mode insertion
  opts = {
    check_ts = true, -- Utilise treesitter pour éviter les faux positifs
    ts_config = {
      -- Ne pas fermer les quotes dans les commentaires ou strings Lua
      lua  = { "string", "source" },
      javascript = { "string", "template_string" },
      typescript = { "string", "template_string" },
    },
    -- Ne pas ajouter de paire si le caractère suivant est déjà le même
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
    fast_wrap = {
      -- Alt+e pour entourer le mot sous le curseur avec une paire
      map            = "<M-e>",
      chars          = { "{", "[", "(", '"', "'" },
      pattern        = [=[[%'%"%>%]%)%}%,]]=],
      end_key        = "$",
      before_key     = "h",
      after_key      = "l",
      cursor_pos_before = true,
      keys           = "qwertyuiopzxcvbnmasdfghjkl",
      highlight      = "Search",
      highlight_grey = "Comment",
    },
  },
}
