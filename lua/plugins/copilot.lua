-- Plugin : GitHub Copilot (avec texte fantôme et déclenchement manuel)

return {
  "zbirenbaum/copilot.lua",
  lazy = false,
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        accept = "<S-Tab>", -- Shift + Tab pour valider le texte fantôme Copilot
        accept_word = false,
        accept_line = false,
        next = "<M-]>",     -- Alt + ] pour suggestion suivante
        prev = "<M-[>",     -- Alt + [ pour suggestion précédente
        dismiss = "<C-]>",  -- Ctrl + ] pour masquer
      },
    },
    panel = { enabled = false },
  },
  config = function(_, opts)
    require("copilot").setup(opts)

    -- Alt + c : Forcer Copilot à générer immédiatement une proposition
    vim.keymap.set("i", "<M-c>", function()
      require("copilot.suggestion").trigger()
    end, { desc = "Forcer une suggestion Copilot" })
  end,
}
