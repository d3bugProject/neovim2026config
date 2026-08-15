-- Plugin : hop.nvim (Saut de curseur ultra-rapide)
-- 'm'  + 1 caractère → demande 1 caractère et saute dessus
-- 'mm' + 1 mot       → demande de saisir un mot et saute directement dessus

return {
  "smoka7/hop.nvim",
  version = "*",
  opts = {
    keys = "etovxqpdygfblzhckisuran",
  },
  keys = {
    {
      "m",
      function()
        require("hop").hint_char1()
      end,
      mode = { "n", "x", "o" },
      desc = "Hop : Sauter vers 1 caractère",
    },
    {
      "mm",
      function()
        require("hop").hint_patterns()
      end,
      mode = { "n", "x", "o" },
      desc = "Hop : Demander un mot et sauter dessus",
    },
  },
}
