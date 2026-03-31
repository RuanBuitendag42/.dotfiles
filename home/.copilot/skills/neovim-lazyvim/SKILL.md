---
name: neovim-lazyvim
description: "Beginner-friendly LazyVim plugin management, LSP, keymaps, lua patterns, and productivity setup"
---

# Neovim + LazyVim Beginner Reference

A beginner-friendly guide to Neovim with LazyVim. Everything is explained simply — think of this as your "LazyVim for VS Code users" handbook.

---

## What is LazyVim?

- **Neovim** is a terminal-based text editor (like VS Code but in your terminal)
- **LazyVim** is a pre-configured Neovim setup that gives you a full IDE out of the box
- It uses **lazy.nvim** as the plugin manager (handles installing/updating plugins)
- You customize by adding Lua files in `lua/plugins/`
- Think of it as "VS Code but running in the terminal" — same concepts, different interface

---

## Directory Structure Explained

```
config/nvim/
├── init.lua              # Entry point — DON'T TOUCH this
├── lazyvim.json          # LazyVim extras — enabled feature packs
├── stylua.toml           # Lua code formatter config
└── lua/
    ├── config/
    │   ├── autocmds.lua  # Auto-triggered actions (like "on file save, do X")
    │   ├── keymaps.lua   # YOUR custom keyboard shortcuts
    │   ├── lazy.lua      # Bootstrap code — DON'T TOUCH this
    │   └── options.lua   # Neovim settings (like VS Code settings.json)
    └── plugins/
        ├── colorscheme.lua  # Theme setup (Catppuccin Macchiato)
        ├── dashboard.lua    # Start screen customization
        └── ui.lua           # UI tweaks
```

**Where to put YOUR stuff:**
- Custom keybinds → `lua/config/keymaps.lua`
- Editor settings → `lua/config/options.lua`
- New plugins → create a new file in `lua/plugins/` (any name ending in `.lua`)
- Auto-commands → `lua/config/autocmds.lua`

---

## How to Add Plugins

Create a new `.lua` file in `lua/plugins/`. The filename doesn't matter — LazyVim auto-loads everything in that folder.

### Basic Plugin Addition
```lua
-- lua/plugins/myplugin.lua
return {
  "author/plugin-name",
  opts = {
    -- plugin settings go here
  },
}
```

### Plugin with Keybinds
```lua
return {
  "author/plugin-name",
  keys = {
    { "<leader>xx", "<cmd>PluginCommand<cr>", desc = "Do something" },
  },
  opts = {},
}
```

### Plugin that Only Loads for Certain Files
```lua
return {
  "author/plugin-name",
  ft = { "python", "lua" },  -- Only loads for these file types
  opts = {},
}
```

### Multiple Plugins in One File
```lua
return {
  { "author/plugin-one", opts = {} },
  { "author/plugin-two", opts = {} },
}
```

### Disable a Default Plugin
```lua
return {
  "plugin/name",
  enabled = false,
}
```

---

## Essential Keymaps

`<leader>` = Space key. Press Space and wait — **which-key** will show you all options!

### File Navigation (like VS Code Ctrl+P)

| Key | What it does | VS Code equivalent |
|-----|-------------|-------------------|
| `<Space>ff` | Find files by name | `Ctrl+P` |
| `<Space>fg` | Search text in ALL files | `Ctrl+Shift+F` |
| `<Space>fr` | Recent files | Recent files list |
| `<Space>fb` | Open buffers (open files) | Tab list |
| `<Space>e` | File explorer (sidebar) | Explorer sidebar |
| `<Space>E` | File explorer (current dir) | — |

### Code Navigation (like VS Code F12)

| Key | What it does | VS Code equivalent |
|-----|-------------|-------------------|
| `gd` | Go to definition | `F12` |
| `gr` | Find all references | `Shift+F12` |
| `gI` | Go to implementation | `Ctrl+F12` |
| `gy` | Go to type definition | — |
| `K` | Hover docs (show info popup) | `Ctrl+hover` |
| `<Space>ca` | Code actions (quick fixes) | `Ctrl+.` |
| `<Space>cr` | Rename symbol | `F2` |
| `<Space>cf` | Format file | `Shift+Alt+F` |
| `<Space>cd` | Line diagnostics | Hover on error |

### Diagnostics (like VS Code Problems panel)

| Key | What it does |
|-----|-------------|
| `]d` | Next diagnostic (error/warning) |
| `[d` | Previous diagnostic |
| `<Space>xx` | Trouble panel (all diagnostics) |
| `<Space>xX` | Buffer diagnostics only |

### Window Management

| Key | What it does |
|-----|-------------|
| `<Space>-` | Split horizontal |
| `<Space>\|` | Split vertical |
| `Ctrl+h/j/k/l` | Move between splits (works with tmux too!) |
| `<Space>wd` | Close current split |

### Buffer (File) Management

| Key | What it does |
|-----|-------------|
| `<Space>bd` | Close current buffer |
| `<Space>bo` | Close all other buffers |
| `[b` | Previous buffer |
| `]b` | Next buffer |
| `<Space>,` | Switch buffer (with preview) |

### Git

| Key | What it does |
|-----|-------------|
| `<Space>gg` | Open Lazygit (full git GUI in terminal!) |
| `<Space>gf` | Git files |
| `<Space>gc` | Git commits |
| `]h` | Next git hunk (change) |
| `[h` | Previous git hunk |

### Search & Replace

| Key | What it does |
|-----|-------------|
| `<Space>sr` | Search and replace (Spectre) |
| `<Space>ss` | Search symbols in file |
| `<Space>sS` | Search symbols in workspace |
| `/` | Search in current file |
| `n` / `N` | Next / previous match |

### General

| Key | What it does |
|-----|-------------|
| `<Space>qq` | Quit Neovim |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `.` | Repeat last action |
| `gcc` | Toggle line comment |
| `gc` (visual) | Toggle comment selection |

---

## LSP Setup (Language Servers)

LSP = Language Server Protocol. It's what gives you autocomplete, go-to-definition, errors, etc. (Same technology VS Code uses!)

### How it Works
1. LazyVim uses **Mason** to auto-install language servers
2. When you open a file, Mason installs the right server automatically
3. You get autocomplete, diagnostics, formatting — everything

### Common Language Servers

| Language | Server | Auto-installed? |
|----------|--------|----------------|
| Lua | `lua_ls` | Yes (LazyVim default) |
| TypeScript/JS | `ts_ls` | Via extras |
| Python | `pyright` or `basedpyright` | Via extras |
| Rust | `rust_analyzer` | Via extras |
| Bash/ZSH | `bashls` | Via extras |
| CSS | `cssls` | Via extras |
| HTML | `html` | Via extras |
| JSON | `jsonls` | Yes (LazyVim default) |
| YAML | `yamlls` | Via extras |
| Go | `gopls` | Via extras |
| Docker | `dockerls` | Via extras |

### Enable Language Extras
Edit `lazyvim.json` or use `:LazyExtras` interactively:
```json
{
  "extras": [
    "lazyvim.plugins.extras.lang.typescript",
    "lazyvim.plugins.extras.lang.python",
    "lazyvim.plugins.extras.lang.rust",
    "lazyvim.plugins.extras.lang.docker"
  ]
}
```

### Manual Server Config
```lua
-- lua/plugins/lsp.lua
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      bashls = {},
      cssls = {},
      html = {},
    },
  },
}
```

### Useful LSP Commands
| Command | What it does |
|---------|-------------|
| `:Mason` | Open Mason UI (install/manage servers) |
| `:LspInfo` | Show active language servers |
| `:LspRestart` | Restart language servers |
| `:LspLog` | View LSP logs (for debugging) |

---

## Plugin Recommendations

### Navigation

**telescope.nvim** (built-in) — Fuzzy finder for everything. Already installed.

**harpoon** — Bookmark files for instant switching (like pinned tabs):
```lua
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon add" },
    { "<leader>hh", function() local harpoon = require("harpoon"); harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon menu" },
    { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon 1" },
    { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon 2" },
    { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon 3" },
    { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon 4" },
  },
  opts = {},
}
```

**flash.nvim** (built-in) — Jump to any visible text. Press `s` then type characters to jump.

### Productivity

**which-key** (built-in) — Shows available keybinds when you press leader. Just press Space and read!

**trouble.nvim** (built-in) — Better diagnostics list (like VS Code Problems panel).

**mini.surround** (built-in) — Add/change/delete brackets and quotes:
- `sa` — surround add (e.g., `saiw"` = surround inner word with `"`)
- `sd` — surround delete (e.g., `sd"` = delete surrounding `"`)
- `sr` — surround replace (e.g., `sr"'` = replace `"` with `'`)

**todo-comments** (built-in) — Highlights `TODO`, `FIXME`, `HACK`, `NOTE` in code:
- `<Space>st` — Search all TODOs in project

### UI / Aesthetics

**catppuccin/nvim** — Catppuccin Macchiato theme (**MUST use**):
```lua
-- Already in lua/plugins/colorscheme.lua
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = { flavour = "macchiato" },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin-macchiato" },
  },
}
```

**noice.nvim** (built-in) — Better command line, search, and notifications.

**indent-blankline** (built-in) — Shows indent guides.

### Writing / Notes

**obsidian.nvim** — If you use Obsidian for notes:
```lua
return {
  "epwalsh/obsidian.nvim",
  ft = "markdown",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    workspaces = {
      { name = "notes", path = "~/Notes" },
    },
  },
}
```

**markdown-preview.nvim** — Live preview in browser:
```lua
return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview" },
  build = function() vim.fn["mkdp#util#install"]() end,
  keys = {
    { "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
  },
  ft = "markdown",
}
```

---

## Lua Config Patterns for Beginners

### Override a LazyVim Default Plugin
```lua
-- If LazyVim already includes a plugin but you want to change its config:
return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- opts contains the existing config — modify it
    opts.options.theme = "catppuccin"
    return opts
  end,
}
```

### Add Keymaps
```lua
-- In lua/config/keymaps.lua
local map = vim.keymap.set

-- Save with Ctrl+S (like VS Code!)
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move line up" })
```

### Set Options
```lua
-- In lua/config/options.lua
local opt = vim.opt

opt.relativenumber = true   -- Relative line numbers (helps with jumping)
opt.scrolloff = 8           -- Keep 8 lines visible above/below cursor
opt.wrap = false            -- Don't wrap long lines
opt.tabstop = 4             -- Tab = 4 spaces
opt.shiftwidth = 4          -- Indent = 4 spaces
opt.expandtab = true        -- Use spaces, not tabs
opt.clipboard = "unnamedplus" -- Use system clipboard
```

### Auto-Commands
```lua
-- In lua/config/autocmds.lua

-- Highlight yanked (copied) text briefly
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
})
```

---

## Common Commands

| Command | What it does |
|---------|-------------|
| `:Lazy` | Plugin manager UI — install, update, clean plugins |
| `:Mason` | LSP/formatter/linter manager — install language support |
| `:checkhealth` | Diagnose issues — run this if something breaks |
| `:LazyExtras` | Enable/disable LazyVim feature packs (languages, tools) |
| `:Telescope` | Open telescope picker |
| `:wq` | Save and quit |
| `:q!` | Quit without saving |
| `:w` | Save |
| `:e filename` | Open a file |
| `:term` | Open terminal inside Neovim |

---

## Modes Explained (for VS Code Users)

Neovim has different "modes" — this is the big difference from VS Code:

| Mode | How to enter | What it's for |
|------|-------------|--------------|
| **Normal** | `Esc` | Navigate, run commands, most keybinds work here |
| **Insert** | `i`, `a`, `o` | Type text (like normal VS Code editing) |
| **Visual** | `v`, `V`, `Ctrl+v` | Select text |
| **Command** | `:` | Run commands (like `:w` to save) |

**Golden rule:** If you're lost, press `Esc` to get back to Normal mode.

### Most Important Motions

| Key | What it does |
|-----|-------------|
| `h/j/k/l` | Left/Down/Up/Right (arrow keys work too) |
| `w` | Jump to next word |
| `b` | Jump to previous word |
| `gg` | Go to top of file |
| `G` | Go to bottom of file |
| `0` | Go to start of line |
| `$` | Go to end of line |
| `%` | Jump to matching bracket |
| `Ctrl+d` | Page down |
| `Ctrl+u` | Page up |
| `zz` | Center screen on cursor |

### Essential Editing

| Key | What it does |
|-----|-------------|
| `i` | Insert before cursor |
| `a` | Insert after cursor |
| `o` | New line below and insert |
| `O` | New line above and insert |
| `dd` | Delete line |
| `yy` | Copy (yank) line |
| `p` | Paste below |
| `P` | Paste above |
| `ciw` | Change inner word (delete word and start typing) |
| `ci"` | Change inside quotes |
| `di(` | Delete inside parentheses |
| `>>` | Indent line |
| `<<` | Unindent line |

---

## Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| Plugin not working | Run `:Lazy` → click Sync |
| No autocomplete | Check `:LspInfo` — is a server running? |
| LSP not installing | Run `:Mason` and install manually |
| Colors look wrong | Make sure terminal supports true color |
| Keys not working | Check `:map <key>` to see what it's mapped to |
| Everything broke | Delete `~/.local/share/nvim` and restart |
| Need more help | Run `:checkhealth` for diagnostics |
