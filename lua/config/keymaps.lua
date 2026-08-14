-- Raccourcis claviers globaux de base

local map = vim.keymap.set

-- Desactiver la recherche sur Echap
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Effacer la recherche" })

-- Navigation entre les fenêtres (Splits) avec Ctrl + h/j/k/l
map("n", "<C-h>", "<C-w>h", { desc = "Fenêtre gauche" })
map("n", "<C-j>", "<C-w>j", { desc = "Fenêtre bas" })
map("n", "<C-k>", "<C-w>k", { desc = "Fenêtre haut" })
map("n", "<C-l>", "<C-w>l", { desc = "Fenêtre droite" })

-- Sauvegarde rapide
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Sauvegarder le fichier" })
map("n", "e", "<cmd>wa<CR>", { desc = "Sauvegarder tous les buffers (:wa)" })

-- Afficher l'historique des messages et erreurs Neovim dans une fenêtre flottante élégante avec Espace + n
map("n", "<leader>n", function()
  local messages = vim.fn.execute("messages")
  local lines = vim.split(messages, "\n")
  
  local clean_lines = {}
  for _, line in ipairs(lines) do
    if line:match("%S") then
      table.insert(clean_lines, "  " .. line)
    end
  end
  
  if #clean_lines == 0 then
    clean_lines = { "", "  ✨ Aucun message ou erreur enregistrée.", "" }
  else
    table.insert(clean_lines, 1, "")
    table.insert(clean_lines, 1, "  ─── Historique des notifications Neovim ───")
    table.insert(clean_lines, "")
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, clean_lines)
  vim.bo[buf].filetype = "markdown"

  local width = math.min(110, math.floor(vim.o.columns * 0.85))
  local height = math.min(25, math.floor(vim.o.lines * 0.8))
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " 🔔 Notifications & Erreurs (Quitter: q / Esc) ",
    title_pos = "center",
  })
  
  -- Curseur en haut et options visuelles
  vim.wo[win].cursorline = true
  vim.wo[win].wrap = true

  vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
  vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = buf, silent = true })
end, { desc = "Afficher les messages/erreurs dans une fenêtre flottante" })


-- Afficher l'erreur du curseur (Diagnostic LSP/Treesitter) avec Espace + d
map("n", "<leader>d", function()
  vim.diagnostic.open_float(nil, { border = "rounded" })
end, { desc = "Afficher le diagnostic sous le curseur" })

-- Raccourci Shift + Q (Q) pour sauvegarder tout et quitter (:wqa)
map("n", "Q", "<cmd>wqa<CR>", { desc = "Sauvegarder tout et quitter Neovim" })

