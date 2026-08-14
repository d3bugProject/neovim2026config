return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      npairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false,
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
          offset = 0,
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      })

      -- Règle spéciale pour Tailwind : ne pas fermer les crochets après className="bg-[
      npairs.add_rules({
        -- Ne pas auto-fermer ] dans les valeurs Tailwind
        Rule("[", "", { "javascript", "javascriptreact", "typescript", "typescriptreact", "html" }):with_pair(
          function(opts)
            local line = opts.line
            local col = opts.col

            -- Si on est dans className="bg-[ ou similar, ne pas auto-fermer
            if line:sub(1, col):match("className=%s*[\"'][^\"']*%-[[]$") then
              return false
            end

            -- Si on est dans une string Tailwind avec des classes arbitraires
            if line:sub(1, col):match("[\"'][^\"']*%-[[]$") then
              return false
            end

            return true
          end
        ),

        -- Auto-fermer normalement dans les autres cas
        Rule("[", "]", { "javascript", "javascriptreact", "typescript", "typescriptreact", "html" }):with_pair(
          function(opts)
            local line = opts.line
            local col = opts.col

            -- Fermer normalement si ce n'est pas du Tailwind
            if
              not line:sub(1, col):match("className=%s*[\"'][^\"']*%-[[]$")
              and not line:sub(1, col):match("[\"'][^\"']*%-[[]$")
            then
              return true
            end

            return false
          end
        ),
      })

      -- Intégration avec nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Plugin bonus pour auto-tag JSX/HTML
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup({
        filetypes = {
          "html",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "svelte",
          "vue",
          "tsx",
          "jsx",
          "rescript",
          "xml",
          "php",
          "markdown",
          "astro",
          "glimmer",
          "handlebars",
          "hbs",
        },
        skip_tags = {
          "area",
          "base",
          "br",
          "col",
          "command",
          "embed",
          "hr",
          "img",
          "slot",
          "input",
          "keygen",
          "link",
          "meta",
          "param",
          "source",
          "track",
          "wbr",
          "menuitem",
        },
      })
    end,
  },
}
