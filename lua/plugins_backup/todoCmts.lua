return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
        test = { "Identifier", "#FF006E" },
        -- Vos couleurs personnalisées
        logic_color = { "#8B5CF6" }, -- Violet pour LOGIC
        component_color = { "#3B82F6" }, -- Bleu pour COMPONENT
        loading_color = { "#F97316" }, -- Orange pour LOADING
        handling_color = { "#10B981" }, -- Vert pour HANDLING
      },
      keywords = {
        -- Vos mots-clés personnalisés
        LOGIC = {
          icon = "🧠",
          color = "logic_color",
          alt = { "logic", "Logic", "LOGIQUE", "logique" },
        },
        COMPONENT = {
          icon = "🧩",
          color = "component_color",
          alt = { "component", "Component", "COMP", "comp" },
        },
        LOADING = {
          icon = "⏳",
          color = "loading_color",
          alt = { "loading", "Loading", "LOAD", "load", "SPINNER", "spinner" },
        },
        HANDLING = {
          icon = "⚡",
          color = "handling_color",
          alt = { "handling", "Handling", "HANDLE", "handle", "HANDLER", "handler" },
        },

        -- Garder quelques classiques si besoin
        FIX = {
          icon = "💉",
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "fix", "fixme", "bug", "fixit", "issue" },
        },
        TODO = {
          icon = "🚀",
          color = "info",
          alt = { "todo", "Todo" },
        },
        NOTE = {
          icon = "📒",
          color = "hint",
          alt = { "INFO", "note", "info", "Note", "Info" },
        },
      },
      highlight = {
        multiline = true,
        multiline_pattern = "^.",
        multiline_context = 10,
        before = "",
        keyword = "wide",
        after = "fg",
        pattern = {
          [[.*<(KEYWORDS)\s*:]], -- Format: LOGIC:
          [[.*\@(KEYWORDS)\s*:]], -- Format: @logic:
          [[.*\#(KEYWORDS)\s*:]], -- Format: #COMPONENT:
          [[.*\/\/(KEYWORDS)\s*:]], -- Format: //LOADING:
          [[.*\/\*\s*(KEYWORDS)\s*:]], -- Format: /* HANDLING:
        },
        comments_only = true,
        max_line_len = 400,
        exclude = {},
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--ignore-case", -- Support maj/minuscules
        },
        pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]],
      },
    },
    event = "VeryLazy",
  },
}
