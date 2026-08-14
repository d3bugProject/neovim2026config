return {
  -- ======================================================
  -- INTERFACE - THÈME SOLARIZED OSAKA
  -- ======================================================
  {
    "craftzdog/solarized-osaka.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("solarized-osaka")
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE", underline = false })
    end,
  },
}
