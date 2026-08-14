return {
  -- ======================================================
  -- NAVIGATION ALTERNATIVE - OIL.NVIM (TEST)
  -- ======================================================
  {
    "stevearc/oil.nvim",
    config = function()
      -- Configuration d'oil.nvim
      require("oil").setup({
        -- DÉSACTIVATION DU HIJACKING AUTOMATIQUE
        default_file_explorer = false, -- Ne pas remplacer netrw par défaut

        -- Colonnes à afficher - Version épurée (icône + nom seulement)
        columns = {
          "icon", -- Icône du type de fichier
          -- Permissions, taille et date supprimées pour un affichage épuré
        },
        -- Utiliser les raccourcis clavier par défaut d'Oil
        use_default_keymaps = true,
        view_options = {
          -- Afficher les fichiers cachés
          show_hidden = false,
        },
      })

      -- Raccourci pour oil.nvim (Space + o)
      vim.keymap.set("n", "<leader>oi", "<cmd>Oil<CR>", { desc = "Ouvrir Oil.nvim" })
    end,
  },
}
