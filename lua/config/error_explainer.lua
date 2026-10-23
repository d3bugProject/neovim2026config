-- Module : Fenêtre flottante d'explication d'erreur en bas à droite
-- Se déclenche au survol de la souris ou sous le curseur (<leader>d)

local M = {}

local current_win = nil
local current_buf = nil

-- Base de connaissances des erreurs courantes JS / TS / React avec explications & solutions claires
local error_knowledge_base = {
  {
    pattern = "is not defined",
    explain = "Vous tentez d'utiliser une variable ou une fonction qui n'a pas été déclarée ou importée.",
    solution = "• Vérifiez l'import en haut du fichier.\n• Vérifiez l'orthographe exacte du nom.",
  },
  {
    pattern = "Cannot find name",
    explain = "TypeScript ne reconnaît pas ce nom dans la portée actuelle ou globale.",
    solution = "• Ajoutez l'import manquant (ex: import { ... } from '...').\n• Si c'est un hook ou composant React, importez-le depuis 'react'.",
  },
  {
    pattern = "Cannot find module",
    explain = "Le fichier ou le paquet spécifié dans le chemin d'import n'existe pas ou est mal orthographié.",
    solution = "• Vérifiez le chemin relatif (ex: ./utils/.. ou ../).\n• Lancez `npm install` si c'est une librairie npm manquante.",
  },
  {
    pattern = "is declared but its value is never read",
    explain = "Cette variable ou cet import a été créé mais n'est jamais utilisé dans le fichier.",
    solution = "• Utilisez la variable ou supprimez-la pour garder le code propre.",
  },
  {
    pattern = "Expected corresponding JSX closing tag",
    explain = "Une balise JSX a été ouverte mais n'a pas été fermée correctement.",
    solution = "• Fermez la balise correspondante (ex: </div>) ou rendez-la auto-fermante (<img ... />).",
  },
  {
    pattern = "Adjacent JSX elements must be wrapped",
    explain = "En React, un composant ne peut retourner qu'un seul élément racine.",
    solution = "• Enveloppez vos balises dans un fragment React : <> ... </> ou dans une <div>.",
  },
  {
    pattern = "Type '.*' is not assignable to type",
    explain = "Le type de la donnée passée ne correspond pas à ce qui est attendu par la variable ou la prop.",
    solution = "• Vérifiez le type attendu (ex: string vs number, ou objet manquant des propriétés).",
  },
  {
    pattern = "Property '.*' does not exist on type",
    explain = "Vous essayez d'accéder à une propriété inexistante sur cet objet ou état.",
    solution = "• Vérifiez l'interface/type de l'objet.\n• Utilisez l'optional chaining (?.) si la valeur peut être undefined (ex: obj?.propriete).",
  },
  {
    pattern = "Objects are not valid as a React child",
    explain = "Vous tentez d'afficher directement un objet JavaScript dans le JSX.",
    solution = "• Affichez une propriété spécifique de l'objet (ex: {user.nom}) ou JSON.stringify(obj).",
  },
  {
    pattern = "Invalid DOM property",
    explain = "Vous avez utilisé un attribut HTML classique qui a un nom différent en JSX.",
    solution = "• Utilisez `className` au lieu de `class`, `htmlFor` au lieu de `for`.",
  },
}

local function find_advice(message)
  for _, item in ipairs(error_knowledge_base) do
    if message:match(item.pattern) then
      return item.explain, item.solution
    end
  end
  return "Analyse du serveur de langage (LSP / Linter).", "• Lisez attentivement le message d'erreur pour identifier la ligne et le paramètre en cause."
end

function M.close()
  if current_win and vim.api.nvim_win_is_valid(current_win) then
    vim.api.nvim_win_close(current_win, true)
  end
  current_win = nil
  current_buf = nil
end

function M.show_at(bufnr, lnum, col)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(bufnr) then return end

  -- Récupérer les diagnostics sur la ligne
  local diagnostics = vim.diagnostic.get(bufnr, { lnum = lnum })
  if not diagnostics or #diagnostics == 0 then
    M.close()
    return
  end

  -- Priorité à l'erreur sous la colonne du curseur/souris, sinon la première
  local diag = diagnostics[1]
  if col then
    for _, d in ipairs(diagnostics) do
      if col >= d.col and col <= (d.end_col or (d.col + 1)) then
        diag = d
        break
      end
    end
  end

  local severity_label = "ERREUR"
  local severity_icon = " "
  local title_hl = "DiagnosticError"

  if diag.severity == vim.diagnostic.severity.WARN then
    severity_label = "ATTENTION"
    severity_icon = " "
    title_hl = "DiagnosticWarn"
  elseif diag.severity == vim.diagnostic.severity.INFO then
    severity_label = "INFORMATION"
    severity_icon = " "
    title_hl = "DiagnosticInfo"
  elseif diag.severity == vim.diagnostic.severity.HINT then
    severity_label = "INDICATION"
    severity_icon = " "
    title_hl = "DiagnosticHint"
  end

  local explain, solution = find_advice(diag.message)

  local lines = {}
  table.insert(lines, "")
  table.insert(lines, "  " .. severity_icon .. " " .. severity_label .. " : " .. (diag.source or "LSP"))
  table.insert(lines, "  " .. string.rep("─", 44))
  table.insert(lines, "")

  -- Découpage du message original
  local msg_lines = vim.split(diag.message, "\n")
  for _, ml in ipairs(msg_lines) do
    table.insert(lines, "  " .. ml)
  end

  table.insert(lines, "")
  table.insert(lines, "  💡 Pourquoi cette erreur :")
  local exp_lines = vim.split(explain, "\n")
  for _, el in ipairs(exp_lines) do
    table.insert(lines, "  " .. el)
  end

  table.insert(lines, "")
  table.insert(lines, "  🛠️ Solution recommandée :")
  local sol_lines = vim.split(solution, "\n")
  for _, sl in ipairs(sol_lines) do
    table.insert(lines, "  " .. sl)
  end
  table.insert(lines, "")

  -- Dimensions
  local max_len = 0
  for _, l in ipairs(lines) do
    if #l > max_len then max_len = #l end
  end

  local width = math.max(48, math.min(max_len + 4, 70))
  local height = math.min(#lines, 18)

  -- Positionnement strict en bas à droite de l'éditeur
  local editor_cols = vim.o.columns
  local editor_lines = vim.o.lines
  local row = math.max(1, editor_lines - height - 3)
  local col_pos = math.max(1, editor_cols - width - 2)

  -- Création du buffer si nécessaire
  if not current_buf or not vim.api.nvim_buf_is_valid(current_buf) then
    current_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[current_buf].bufhidden = "wipe"
    vim.bo[current_buf].filetype = "markdown"
  end

  vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, lines)

  -- Création ou mise à jour de la fenêtre
  if current_win and vim.api.nvim_win_is_valid(current_win) then
    vim.api.nvim_win_set_config(current_win, {
      relative = "editor",
      row = row,
      col = col_pos,
      width = width,
      height = height,
    })
  else
    current_win = vim.api.nvim_open_win(current_buf, false, {
      relative = "editor",
      row = row,
      col = col_pos,
      width = width,
      height = height,
      style = "minimal",
      border = "rounded",
      focusable = false,
      title = " " .. severity_icon .. " Diagnostic & Solution ",
      title_pos = "right",
    })
  end

  -- Fermer si la touche Esc est pressée dans le buffer source
  vim.keymap.set("n", "<Esc>", function()
    M.close()
    vim.cmd("nohlsearch")
  end, { buffer = bufnr, silent = true, nowait = true })

  -- Fermer si 'q' ou 'Esc' est pressé dans la fenêtre flottante elle-même
  vim.keymap.set("n", "q", function()
    M.close()
  end, { buffer = current_buf, silent = true, nowait = true })
  vim.keymap.set("n", "<Esc>", function()
    M.close()
  end, { buffer = current_buf, silent = true, nowait = true })
end

-- Survol souris avec <MouseMove>
function M.setup()
  vim.on_key(function(key)
    -- Ferme la popup si l'utilisateur change de mode ou tape
    if current_win and (key == "\27" or key == "i" or key == "a") then
      M.close()
    end
  end)

  -- Gestionnaire souris Neovim
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    callback = function()
      -- Fermer la popup quand le curseur bouge loin
      if current_win and vim.api.nvim_win_is_valid(current_win) then
        local current_l = vim.fn.line(".") - 1
        local diags = vim.diagnostic.get(0, { lnum = current_l })
        if #diags == 0 then
          M.close()
        end
      end
    end,
  })
end

return M
