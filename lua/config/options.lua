-- Options de base Neovim

-- Leader Key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Interface & Visuel
vim.opt.number = true          -- Affiche les numéros de ligne
vim.opt.relativenumber = true  -- Numéros de ligne relatifs pour des déplacements rapides
vim.opt.termguicolors = true   -- Active les couleurs 24-bit TrueColor
vim.opt.signcolumn = "yes"     -- Toujours afficher la colonne des signes (LSP / Git)
vim.opt.cursorline = true      -- Surligner la ligne courante
vim.opt.scrolloff = 8          -- Garder au moins 8 lignes au-dessus/en-dessous du curseur
vim.opt.fillchars = { eob = " " } -- Masquer les tildes (~) en fin de fichier
vim.opt.showmode = false       -- Masquer le mode "-- INSERT --" par défaut (sera géré proprement par lualine/statusline)
vim.opt.mouse = "a"            -- Activer la souris de manière fluide
vim.opt.pumheight = 10         -- Limiter la hauteur du menu déroulant de complétion
vim.opt.wrap = false           -- Ne pas couper les lignes par défaut (défilement horizontal plus fluide)
vim.opt.smoothscroll = true    -- Scrolling fluide ligne par ligne (Neovim >= 0.10)

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Recherche
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Comportement système
vim.opt.clipboard = "unnamedplus" -- Synchroniser avec le presse-papier système
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.updatetime = 250         -- Temps de réponse plus rapide (par défaut 4000ms)
vim.opt.timeoutlen = 300         -- Délai pour les raccourcis composés (ex: which-key)
vim.opt.undofile = true          -- Persistance de l'historique d'annulation (Undo) même après fermeture

-- Désactiver les notifications de déprécation internes Neovim
vim.deprecate = function() end


