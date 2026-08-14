-- Configuration de lazy.nvim avec tolérance réseau (Algérie Télécom / VPN)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Échec de l'installation de lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nAppuyez sur une touche pour quitter..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins" },
}, {
  defaults = { lazy = true },
  checker = { enabled = false },
  git = {
    timeout = 300, -- Augmente le délai d'attente Git à 5 minutes pour les connexions lentes
    filter = false, -- Désactive les filtres blobs qui échouent parfois sur certains FAI
  },
  git_url_sub = nil,
  concurrency = 2, -- Limite les téléchargements simultanés pour éviter de saturer la connexion
})
