-- Plugin : nvim-ts-autotag (Fermeture et renommage automatique des balises HTML/JSX/TSX)

return {
  "windwp/nvim-ts-autotag",
  event = { "BufReadPost", "BufNewFile" },
  opts = {},
}
