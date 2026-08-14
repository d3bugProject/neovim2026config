return {
  -- ======================================================
  -- nvim colorizer il fait genre les couleur du hex et tt
  -- ======================================================
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" }, -- active partout
        user_default_options = {
          tailwind = true, -- support tailwind
          names = false, -- désactive les noms genre "red"
        },
      })
    end,
    event = "BufReadPre",
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end,
  },
}
