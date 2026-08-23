<div align="center">

# ⚡ Neovim 2026 Config

### *The Blazing-Fast, AI-Powered & Zero-Friction Development Environment for React, React Native, TypeScript & Beyond.*

[![Neovim](https://img.shields.io/badge/Neovim-0.12+-57A143?style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Lua-5.1_/_LuaJIT-2C5BB4?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org)
[![GitHub Copilot](https://img.shields.io/badge/GitHub_Copilot-Enabled-6F42C1?style=for-the-badge&logo=githubcopilot&logoColor=white)](https://github.com/features/copilot)
[![Blink.cmp Engine](https://img.shields.io/badge/Blink.cmp-Rust_Engine-DEA584?style=for-the-badge&logo=rust&logoColor=white)](https://github.com/saghen/blink.cmp)
[![License](https://img.shields.io/badge/License-MIT-blue.style=for-the-badge)](LICENSE)

<p align="center">
  <a href="#-key-features">Key Features</a> •
  <a href="#-keybindings-cheat-sheet">Keybindings</a> •
  <a href="#-plugin-ecosystem">Plugin Ecosystem</a> •
  <a href="#-quick-start--installation">Installation</a>
</p>

---

</div>

## 🌟 Why Neovim 2026 Config?

Crafted from the ground up to deliver an **unmatched developer experience (DX)**, this Neovim configuration combines cutting-edge **Rust-powered autocompletion**, **seamless GitHub Copilot AI ghost-text**, **instant cursor teleportation**, and **clean zero-friction formatting** — all while maintaining **sub-10ms startup times** and zero runtime errors.

Whether you're crafting complex **React / Next.js** applications, building cross-platform **React Native** apps, or writing modern **TypeScript**, this config equips you with an IDE-grade environment in a ultra-lightweight terminal shell.

---

## 🔥 Key Features & Advantages

### 🤖 1. Seamless GitHub Copilot AI Integration
- **Ghost-Text Completion**: As you type, Copilot suggests intelligent code in inline translucent text.
- **One-Tap Acceptance**: Accept Copilot suggestions instantly with `<S-Tab>` (Shift + Tab).
- **On-Demand AI Generation**: Force Copilot code generation anytime with `<Alt+c>`.
- **Zero-Lag Architecture**: Copilot runs unobtrusively in the background without modal popups or picker freezes.

### 🏎️ 2. Rust-Powered Autocompletion Engine (`blink.cmp`)
- Powered by `blink.cmp`'s precompiled Rust fuzzy matching engine (`.dll` / `.so`).
- Handles **23,000+ Tailwind CSS v4 classes** and full TypeScript AST trees with **0ms typing latency**.
- Built-in snippet expansion and path completion.

### ⚛️ 3. Next-Gen React & React Native Snippet Ecosystem
- **Instant Components**: Generate functional components in milliseconds:
  - `rfc` → React Functional Component
  - `rafce` → React Arrow Function Component with Export
  - `rnfe` → React Native Functional Export with `StyleSheet` & `View`/`Text`
  - `rnfs` → React Native Component with `StyleSheet`
- **Smart Attributes & Hooks**:
  - `cn` → Expands directly to `className={` ... `}`
  - `ufe` / `useEffect` → `useEffect(() => { ... }, []);`
  - `ust` / `useState` → `const [state, setState] = useState();`
- **Fluid `<Tab>` Jumping**: Seamlessly jump through snippet placeholders (`$1` → `$2` → `$3`) with `<Tab>` and `<S-Tab>`.

### 🎯 4. Instant Cursor Teleportation (`hop.nvim`)
- **`m` + Character**: Prompts for 1 character and displays hints for 1-tap jumping anywhere on screen.
- **`mm` + Word**: Prompts for a word pattern and teleports the cursor directly to the match.

### 🎨 5. Zero-Friction Formatting (Prettier & Stylua)
- **Automatic Format-on-Save**: Formats your code effortlessly with Prettier on every `:w`.
- **Clean JSX Output**: Prettier is pre-configured with `--html-whitespace-sensitivity ignore` and `--print-width 120` to prevent ugly `{" "}` text wraps in JSX/HTML.

### 🔍 6. Ultra-Fast Fuzzy Picker (`snacks.nvim`)
- `<Space><Space>` → Instantly search files across the project workspace.
- `<Space>s` → Live grep text search across all codebase files with automatic `node_modules` and `.git` filtering.

### 🛡️ 7. Rock-Solid & Zero-Error Stability
- Built for **Neovim 0.12+** using native C/Lua Treesitter syntax highlighting.
- Silenced internal deprecation notices and auto-cleaned buffer locks for a pristine experience.

---

## ⌨️ Keybindings Cheat Sheet

### 🚀 Navigation & Editing
| Shortcut | Mode | Description |
|---|---|---|
| `<Ctrl-a>` | `Normal`, `Insert`, `Visual` | **Select All** lines in buffer |
| `<C-s>` | `Normal`, `Insert`, `Visual`, `Select` | Save current file (`:w`) |
| `e` | `Normal` | Save all open buffers (`:wa`) |
| `x` | `Normal` | Close current buffer (`:bd`) |
| `X` | `Normal` | Close all buffers (`:%bd`) |
| `Q` | `Normal` | Save all & Quit Neovim (`:wqa`) |
| `<Esc>` | `Normal` | Clear search highlight (`:nohlsearch`) |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | `Normal` | Move to left / down / up / right split window |

### 🤖 GitHub Copilot AI & Autocompletion
| Shortcut | Mode | Description |
|---|---|---|
| `<S-Tab>` | `Insert` | **Accept Copilot Ghost-Text** (if visible) / Previous completion / Jump snippet step backward |
| `<Alt+c>` (`<M-c>`) | `Insert` | **Force Copilot AI suggestion** on demand |
| `<Alt+]>` (`<M-]>`) | `Insert` | Cycle to next Copilot suggestion |
| `<Alt+[`> (`<M-[>`) | `Insert` | Cycle to previous Copilot suggestion |
| `<Ctrl-]>` (`<C-]>`) | `Insert` | Dismiss current Copilot suggestion |
| `<Tab>` | `Insert` | Select next completion item / Jump snippet step forward |
| `<CR>` (Enter) | `Insert` | Accept completion suggestion / Expand snippet |
| `<C-Space>` | `Insert` | Trigger autocompletion menu manually / Show-hide documentation |

### 🎯 Hop Teleportation
| Shortcut | Mode | Description |
|---|---|---|
| `m` | `Normal`, `Visual`, `Operator` | Teleport to 1 target character on screen |
| `mm` | `Normal`, `Visual`, `Operator` | Search & teleport to word pattern |

### 🔍 Search & Explorers
| Shortcut | Mode | Description |
|---|---|---|
| `<Space><Space>` | `Normal` | Search files in project workspace (Snacks picker) |
| `<Space>s` | `Normal` | Live grep text search across project (Snacks picker) |
| `<Space>e` | `Normal` | Toggle Floating File Explorer (Neo-tree) |
| `<Space>o` | `Normal` | Open floating directory editor (Oil.nvim) |
| `<Space>f` | `Normal` | Format file manually (Prettier / Stylua via Conform) |
| `<Space>d` | `Normal` | Show LSP diagnostic / error under cursor |
| `<Space>n` | `Normal` | Open Neovim Notification & Error History window (`c` to clear, `q`/`<Esc>` to close) |

---

## 🔌 Plugin Ecosystem

| Category | Plugin | Description |
|---|---|---|
| **AI Completion** | [`zbirenbaum/copilot.lua`](https://github.com/zbirenbaum/copilot.lua) | Pure Lua GitHub Copilot integration with ghost-text |
| **Completion Engine** | [`saghen/blink.cmp`](https://github.com/saghen/blink.cmp) | Ultra-fast Rust-powered autocompletion engine |
| **Snippet Engine** | [`L3MON4D3/LuaSnip`](https://github.com/L3MON4D3/LuaSnip) | Powerful VSCode & custom snippet expansion engine |
| **Snippet Packs** | [`friendly-snippets`](https://github.com/rafamadriz/friendly-snippets) & [`vscode-es7-react-snippets`](https://github.com/dsznajder/vscode-es7-javascript-react-snippets) | Comprehensive collection of React, React Native, JS & TS snippets |
| **Teleportation** | [`smoka7/hop.nvim`](https://github.com/smoka7/hop.nvim) | Neovim 0.10+ fast motion teleportation plugin |
| **Fuzzy Picker** | [`folke/snacks.nvim`](https://github.com/folke/snacks.nvim) | Modern, lightweight file & live grep picker + AllBlue Dashboard |
| **File Explorer** | [`nvim-neo-tree/neo-tree.nvim`](https://github.com/nvim-neo-tree/neo-tree.nvim) | Floating file explorer tree |
| **Buffer Explorer** | [`stevearc/oil.nvim`](https://github.com/stevearc/oil.nvim) | Edit file directory system like a normal vim buffer in a floating window |
| **Formatting** | [`stevearc/conform.nvim`](https://github.com/stevearc/conform.nvim) | Asynchronous auto-formatter (Prettier & Stylua) |
| **Package Manager** | [`williamboman/mason.nvim`](https://github.com/williamboman/mason.nvim) | Automatic installer for LSP servers & formatters |
| **LSP Bridge** | [`neovim/nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig) | Native Neovim LSP configuration |
| **Syntax Parser** | [`nvim-treesitter/nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter) | Universal incremental code parser & highlighter |
| **Auto-Pairs** | [`windwp/nvim-autopairs`](https://github.com/windwp/nvim-autopairs) & [`autotag`](https://github.com/windwp/nvim-ts-autotag) | Automatic closing of parens, quotes, brackets & HTML/JSX tags |
| **Color Highlights** | [`NvChad/nvim-colorizer.lua`](https://github.com/NvChad/nvim-colorizer.lua) | Real-time HEX, RGB & Tailwind CSS color previews |
| **Rainbow Delimiters** | [`HiPhish/rainbow-delimiters.nvim`](https://github.com/HiPhish/rainbow-delimiters.nvim) | Colorful parentheses, brackets, and JSX/TSX tag highlighting |
| **Theme** | [`craftzdog/solarized-osaka.nvim`](https://github.com/craftzdog/solarized-osaka.nvim) | Modern, vivid dark colorscheme inspired by TokyoNight & Solarized |

---

## 🚀 Quick Start & Installation

### 1. Prerequisites
Ensure you have **Neovim 0.12+** and **Git** installed on your system:
- **Windows**: `winget install Neovim.Neovim`
- **macOS**: `brew install neovim`
- **Linux**: Install via your package manager or AppImage.

### 2. One-Line Installation

#### **Windows (PowerShell)**:
```powershell
git clone https://github.com/d3bugProject/neovim2026config.git $env:LOCALAPPDATA\nvim
```

#### **macOS / Linux (Bash/Zsh)**:
```bash
git clone https://github.com/d3bugProject/neovim2026config.git ~/.config/nvim
```

### 3. First Launch & Copilot Auth
1. Open Neovim:
   ```bash
   nvim
   ```
   *Lazy.nvim will automatically download all plugins, LSP servers, and formatters in the background.*

2. Authenticate GitHub Copilot (one-time setup):
   ```vim
   :Copilot auth
   ```
   *Follow the link and device code to link your GitHub Copilot account.*

---

<div align="center">

Crafted with ❤️ for high-productivity developers.

**[⭐ Star this repository](https://github.com/d3bugProject/neovim2026config)** if you find it helpful!

</div>
