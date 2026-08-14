-- Avante est trop buggé, voici la config qui MARCHE
return {
  -- Copilot officiel - ZERO bugs
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      -- Désactiver Tab
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""

      -- Alt+l: Accepter suggestion (version qui marchait + fix <80>@7)
      vim.keymap.set("i", "<A-l>", function()
        local suggestion = vim.fn["copilot#Accept"]("")
        if suggestion ~= "" then
          -- Nettoyer les caractères d'encoding bizarres
          local clean_suggestion = suggestion:gsub("<80>@%d+", "")
          vim.api.nvim_feedkeys(clean_suggestion, "i", true)
        end
      end, {
        desc = "Accept Copilot suggestion",
        silent = true,
      })

      -- Toggle Copilot avec plusieurs alternatives de touches
      local function toggle_copilot()
        local is_enabled = vim.fn["copilot#Enabled"]() == 1
        if is_enabled then
          vim.cmd("Copilot disable")
          print("🔴 Copilot: DISABLED")
        else
          vim.cmd("Copilot enable")
          print("🟢 Copilot: ENABLED")
        end
      end

      -- Essayer plusieurs combinaisons
      vim.keymap.set({ "n", "i" }, "<A-m>", toggle_copilot, { desc = "Toggle Copilot", silent = false })
      vim.keymap.set({ "n", "i" }, "<M-m>", toggle_copilot, { desc = "Toggle Copilot (alt)", silent = false })
      vim.keymap.set({ "n", "i" }, "<leader>ct", toggle_copilot, { desc = "Toggle Copilot (leader)", silent = false })

      -- Protection Tab explicite
      vim.keymap.set("i", "<Tab>", function()
        if pcall(require, "cmp") and require("cmp").visible() then
          return require("cmp").select_next_item()
        else
          return "<Tab>"
        end
      end, { expr = true, silent = true })
    end,
  },

  -- CopilotChat - Interface propre, ZERO bugs
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("CopilotChat").setup({
        debug = false,
        chat = {
          welcome_message = "👋 Salut ! Comment je peux t'aider avec ton code ?",
          loading_text = "Copilot réfléchit...",
          question_prefix = "## Toi: ",
          answer_prefix = "## Copilot: ",
        },
        prompts = {
          Explain = "Explique ce code de façon simple et claire:",
          Review = "Review ce code et suggère des améliorations:",
          Fix = "Identifie et corrige les bugs dans ce code:",
          Optimize = "Optimise ce code pour de meilleures performances:",
          Refactor = "Refactorise ce code pour une meilleure lisibilité:",
          Tests = "Génère des tests unitaires pour ce code:",
        },
      })

      -- Alt+c: Ouvrir le chat
      vim.keymap.set({ "n", "v" }, "<A-c>", "<Cmd>CopilotChat<CR>", {
        desc = "Open CopilotChat",
        silent = true,
      })

      -- Keymaps avec sélection visuelle
      vim.keymap.set("v", "<leader>ce", "<Cmd>CopilotChatExplain<CR>", {
        desc = "Explain selection",
      })

      vim.keymap.set("v", "<leader>cf", "<Cmd>CopilotChatFix<CR>", {
        desc = "Fix selection",
      })

      vim.keymap.set("v", "<leader>co", "<Cmd>CopilotChatOptimize<CR>", {
        desc = "Optimize selection",
      })

      vim.keymap.set("v", "<leader>cr", "<Cmd>CopilotChatReview<CR>", {
        desc = "Review selection",
      })

      vim.keymap.set("v", "<leader>ct", "<Cmd>CopilotChatTests<CR>", {
        desc = "Generate tests",
      })

      -- Question rapide
      vim.keymap.set("n", "<leader>cq", function()
        local input = vim.fn.input("Question: ")
        if input ~= "" then
          require("CopilotChat").ask(input)
        end
      end, {
        desc = "Quick question",
      })

      -- Toggle sidebar
      vim.keymap.set("n", "<leader>cs", "<Cmd>CopilotChatToggle<CR>", {
        desc = "Toggle CopilotChat sidebar",
      })
    end,
  },
}
