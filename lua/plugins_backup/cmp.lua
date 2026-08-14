return {
  { "saghen/blink.nvim", enabled = false },
  { "saghen/blink.cmp", enabled = false },
  {
    "hrsh7th/nvim-cmp",
    enabled = true,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      -- AJOUT : Support Tailwind avec couleurs
      "roobert/tailwindcss-colorizer-cmp.nvim",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      
      -- Autocmd pour corriger les parenthèses uniquement dans les balises JSX
      vim.api.nvim_create_autocmd({"TextChangedI", "CompleteDone"}, {
        pattern = "*",
        callback = function()
          vim.defer_fn(function()
            local line = vim.api.nvim_get_current_line()
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))
            -- Corrige uniquement <Component()> ou <Component ()>
            local jsx_start, jsx_end, jsx_component = line:find("<(%u%w*)%s*%(%)")
            if jsx_component then
              local new_line = line:gsub("<" .. jsx_component .. "%s*%(%)%s*", "<" .. jsx_component .. " ")
              if new_line ~= line then
                vim.api.nvim_set_current_line(new_line)
                local new_pos = jsx_start + #jsx_component
                vim.api.nvim_win_set_cursor(0, {row, new_pos})
              end
            end
          end, 50)
        end,
      })
      opts.preselect = cmp.PreselectMode.None
      opts.completion = {
        completeopt = "menu,menuone,noselect",
        keyword_length = 1,
      }
      opts.sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        { name = "buffer", priority = 500 },
        { name = "path", priority = 250 },
      })

      -- AJOUT : Formatage pour afficher les couleurs Tailwind
      opts.formatting = {
        format = function(entry, vim_item)
          local tailwind_ok, tailwind_formatter = pcall(require, "tailwindcss-colorizer-cmp")
          if tailwind_ok then
            vim_item = tailwind_formatter.formatter(entry, vim_item)
          end
          return vim_item
        end,
      }

      opts.mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
          local luasnip = require("luasnip")
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          local luasnip = require("luasnip")
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = true })
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
      })
      -- Ferme la fenêtre cmp quand tu navigues dans un snippet
      vim.api.nvim_create_autocmd("User", {
        pattern = "LuasnipJump",
        callback = function()
          local ok, cmp = pcall(require, "cmp")
          if ok and cmp.visible() then
            cmp.close()
          end
        end,
      })
      -- Optionnel : apparence
      opts.window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      }
      return opts
    end,
  },
}
