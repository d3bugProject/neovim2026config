--[[
╭────────────────────────────────────────────────────────────────────────────╮
│  🚀 auto-js-config.nvim                                                    │
│  Générateur automatique de tsconfig.json / jsconfig.json                   │
│                                                                            │
│  🧠 Auto-détection intelligente de projets JS/TS                           │
│  ─ Scanne package.json, tsconfig.json, jsconfig.json, etc.                 │
│  ─ Déclenchement automatique à l'ouverture de Neovim ou changement de dir  │
│                                                                            │
│  🛠️ Configuration sur-mesure                                               │
│  ─ Génère tsconfig.json pour TypeScript, jsconfig.json pour JavaScript     │
│  ─ Support JSX/React (jsx: "react-jsx")                                    │
│  ─ ES6/ESNext activé, alias @/* et ~/*                                     │
│                                                                            │
│  💡 Utilisation                                                            │
│    • Automatique : s’active dès l’ouverture d’un projet JS/TS              │
│    • Manuel   : :CreateJSConfig ou :CreateJSConfigForce                    │
│                                                                            │
│  📦 Installation                                                           │
│    Copier ce fichier dans ~/.config/nvim/lua/plugins/auto-js-config.lua    │
│    ou l’inclure dans votre gestionnaire de plugins préféré                  │
│                                                                            │
│  📝 Contrib : github.com/VOTRE_REPO (ajoutez votre lien !)                  │
╰────────────────────────────────────────────────────────────────────────────╯
]]

return {
  name = "auto-js-config",
  dir = vim.fn.stdpath("config") .. "/lua/plugins",
  config = function()
    local M = {}

    -- Détecte si c'est un projet JavaScript/TypeScript
    local function is_js_project()
      local root_files = {
        "package.json",
        "tsconfig.json",
        "jsconfig.json",
        ".eslintrc.js",
        ".eslintrc.json",
        "next.config.js",
        "vite.config.js",
        "webpack.config.js",
      }

      local root_dir = vim.fn.getcwd()
      for _, file in ipairs(root_files) do
        if vim.fn.filereadable(root_dir .. "/" .. file) == 1 then
          return true
        end
      end
      return false
    end

    -- Détecte si c'est un projet TypeScript
    local function is_typescript_project()
      local root_dir = vim.fn.getcwd()
      local ts_files = {
        "tsconfig.json",
        "tsconfig.base.json",
      }

      for _, file in ipairs(ts_files) do
        if vim.fn.filereadable(root_dir .. "/" .. file) == 1 then
          return true
        end
      end

      -- Vérifier s'il y a des fichiers .ts/.tsx dans le projet
      local has_ts_files = vim.fn.system("find " .. root_dir .. " -name '*.ts' -o -name '*.tsx' | head -1")
      return has_ts_files ~= ""
    end

    -- Contenu du jsconfig.json
    local function get_jsconfig_content()
      return vim.fn.json_encode({
        compilerOptions = {
          target = "ES6",
          module = "ESNext",
          moduleResolution = "node",
          allowSyntheticDefaultImports = true,
          allowJs = true,
          checkJs = false,
          jsx = "react-jsx",
          declaration = false,
          emitDecoratorMetadata = true,
          experimentalDecorators = true,
          lib = { "DOM", "DOM.Iterable", "ES6" },
          skipLibCheck = true,
          strict = false,
          resolveJsonModule = true,
          isolatedModules = true,
          noEmit = true,
          baseUrl = ".",
          paths = {
            ["@/*"] = { "./src/*" },
            ["~/*"] = { "./src/*" },
          },
        },
        include = {
          "src/**/*",
          "app/**/*",
          "pages/**/*",
          "components/**/*",
          "*.js",
          "*.jsx",
        },
        exclude = {
          "node_modules",
          "dist",
          "build",
          ".next",
          ".expo",
        },
      })
    end

    -- Contenu du tsconfig.json
    local function get_tsconfig_content()
      return vim.fn.json_encode({
        compilerOptions = {
          target = "ES2020",
          lib = { "DOM", "DOM.Iterable", "ES6" },
          allowJs = true,
          skipLibCheck = true,
          esModuleInterop = true,
          allowSyntheticDefaultImports = true,
          strict = true,
          forceConsistentCasingInFileNames = true,
          module = "ESNext",
          moduleResolution = "node",
          resolveJsonModule = true,
          isolatedModules = true,
          noEmit = true,
          jsx = "react-jsx",
          declaration = false,
          emitDecoratorMetadata = true,
          experimentalDecorators = true,
          baseUrl = ".",
          paths = {
            ["@/*"] = { "./src/*" },
            ["~/*"] = { "./src/*" },
          },
        },
        include = {
          "src/**/*",
          "app/**/*",
          "pages/**/*",
          "components/**/*",
          "*.ts",
          "*.tsx",
          "*.js",
          "*.jsx",
        },
        exclude = {
          "node_modules",
          "dist",
          "build",
          ".next",
          ".expo",
        },
      })
    end

    -- Crée le fichier de configuration
    local function create_config_file()
      local root_dir = vim.fn.getcwd()
      local is_ts = is_typescript_project()

      if is_ts then
        -- Projet TypeScript
        local tsconfig_path = root_dir .. "/tsconfig.json"
        if vim.fn.filereadable(tsconfig_path) == 0 then
          local content = get_tsconfig_content()
          vim.fn.writefile({ content }, tsconfig_path)
          print("✅ tsconfig.json créé automatiquement")
        end
      else
        -- Projet JavaScript
        local jsconfig_path = root_dir .. "/jsconfig.json"
        if vim.fn.filereadable(jsconfig_path) == 0 then
          local content = get_jsconfig_content()
          vim.fn.writefile({ content }, jsconfig_path)
          print("✅ jsconfig.json créé automatiquement")
        end
      end
    end

    -- Auto-détection à l'ouverture du projet
    local function setup_auto_detection()
      vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
        callback = function()
          if is_js_project() then
            vim.defer_fn(create_config_file, 100) -- Délai pour éviter les conflits
          end
        end,
      })
    end

    -- Commandes manuelles
    vim.api.nvim_create_user_command("CreateJSConfig", function()
      if is_js_project() then
        create_config_file()
      else
        print("❌ Pas de projet JavaScript/TypeScript détecté")
      end
    end, { desc = "Créer jsconfig.json/tsconfig.json" })

    vim.api.nvim_create_user_command("CreateJSConfigForce", function()
      create_config_file()
    end, { desc = "Forcer la création de jsconfig.json/tsconfig.json" })

    -- Initialiser
    setup_auto_detection()

    M.create_config_file = create_config_file
    M.is_js_project = is_js_project
    M.is_typescript_project = is_typescript_project

    return M
  end,
}
