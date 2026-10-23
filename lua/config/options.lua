-- Options de base Neovim

-- Leader Key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Désactiver netrw (évite l'explorateur basique par défaut sur `nvim .`)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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

-- Protection contre les erreurs Treesitter (noeuds nil lors du parsing dynamique)
local orig_get_range = vim.treesitter.get_range
if orig_get_range then
  vim.treesitter.get_range = function(node, source, metadata)
    if not node then
      return { 0, 0, 0, 0 }
    end
    return orig_get_range(node, source, metadata)
  end
end

-- Nettoyage automatique des {" "} et des espaces résiduels JSX avant formatage & sauvegarde
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.jsx", "*.tsx", "*.js", "*.ts" },
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    local old_query = vim.fn.getreg("/")
    -- Supprime les {" "} ou {' '} ou {` `}
    vim.cmd([[%s/{\s*[`'"]\s*[`'"]\s*}//ge]])
    -- Supprime les espaces résiduels en bout de ligne
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setreg("/", old_query)
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Survol souris et affichage d'erreur en bas à droite
local explainer = require("config.error_explainer")
explainer.setup()

-- Survol souris avec <MouseMove>
vim.opt.mousemoveevent = true
vim.keymap.set({ "n", "i", "v" }, "<MouseMove>", function()
  local mouse = vim.fn.getmousepos()
  if mouse.winid > 0 and mouse.line > 0 then
    local bufnr = vim.api.nvim_win_get_buf(mouse.winid)
    local lnum = mouse.line - 1
    local col = mouse.column - 1
    local diags = vim.diagnostic.get(bufnr, { lnum = lnum })
    if #diags > 0 then
      explainer.show_at(bufnr, lnum, col)
    else
      explainer.close()
    end
  end
end, { desc = "Afficher explication d'erreur au survol de la souris" })
