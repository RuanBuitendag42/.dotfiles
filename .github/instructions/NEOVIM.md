# Neovim (LazyVim) Roadmap

> Next steps for leveling up your Neovim skills and config.
> Current base: **LazyVim** with **Catppuccin Macchiato** theme.

---

## Current State

- LazyVim starter config (clean)
- Catppuccin Macchiato colorscheme configured
- No custom keymaps, options, or autocmds yet
- No extra LazyVim "extras" enabled

---

## Phase 1: Learn the Basics (Start Here)

These are about building muscle memory, not config changes.

### Key Concepts to Practice

| Action | Default LazyVim Key | What It Does |
|--------|-------------------|--------------|
| Leader key | `<Space>` | Opens which-key menu — explore this! |
| Find files | `<Space>ff` | Telescope file finder |
| Live grep | `<Space>sg` | Search text across project |
| File explorer | `<Space>e` | Toggle Neo-tree sidebar |
| Buffers | `<Space>bb` | Switch between open files |
| Terminal | `<C-/>` | Toggle floating terminal |
| LSP hover | `K` | Show docs for symbol under cursor |
| Go to definition | `gd` | Jump to where something is defined |
| Code actions | `<Space>ca` | Quick fixes / refactors |
| Format | `<Space>cf` | Format current file |
| Save | `<Space>w` | Save file (or just `:w`) |
| Quit | `<Space>qq` | Quit all |

### Recommended Practice

1. **Use `:Tutor`** — Built-in Vim tutorial (run it first!)
2. **Press `<Space>` and wait** — Which-key shows all available mappings
3. **Don't remap yet** — Learn defaults first, customize later
4. **Use `vimtutor`** in terminal for fundamental motions

---

## Phase 2: Enable LazyVim Extras

LazyVim has curated "extras" — pre-configured plugin bundles you can enable.
Enable them by adding to `lazyvim.json` or via `:LazyExtras` in Neovim.

### Recommended Extras (by priority)

#### Essential
```
lazyvim.plugins.extras.coding.copilot        -- GitHub Copilot integration
lazyvim.plugins.extras.lang.python           -- Python LSP, formatting, debugging
lazyvim.plugins.extras.lang.typescript       -- TypeScript/JS full support
lazyvim.plugins.extras.lang.json             -- JSON schemas + validation
lazyvim.plugins.extras.lang.markdown         -- Markdown preview + editing
```

#### Nice to Have
```
lazyvim.plugins.extras.lang.docker           -- Dockerfile + compose support
lazyvim.plugins.extras.lang.yaml             -- YAML with schema validation
lazyvim.plugins.extras.lang.toml             -- TOML support (for Rust/configs)
lazyvim.plugins.extras.lang.bash             -- Bash/shell scripting
lazyvim.plugins.extras.lang.rust             -- If you ever touch Rust
lazyvim.plugins.extras.lang.go               -- If you ever touch Go
```

#### UI & Editor Enhancements
```
lazyvim.plugins.extras.ui.mini-animate       -- Smooth animations
lazyvim.plugins.extras.editor.mini-files     -- Alternative file explorer
lazyvim.plugins.extras.util.mini-hipatterns  -- Highlight patterns (TODOs, etc.)
```

### How to Enable
In Neovim, run `:LazyExtras` and press `x` on any extra to toggle it.
Or manually edit `lazyvim.json`:
```json
{
  "extras": [
    "lazyvim.plugins.extras.coding.copilot",
    "lazyvim.plugins.extras.lang.python"
  ]
}
```

---

## Phase 3: Custom Options & Keymaps

Once you're comfortable with defaults, personalize in these files:

### `lua/config/options.lua`
```lua
-- Example options to consider
vim.opt.relativenumber = true      -- Relative line numbers (helps with motions)
vim.opt.scrolloff = 8              -- Keep 8 lines visible above/below cursor
vim.opt.wrap = false               -- Don't wrap long lines
vim.opt.colorcolumn = "80"         -- Show column guide at 80 chars
vim.opt.cursorline = true          -- Highlight current line (already default)
```

### `lua/config/keymaps.lua`
```lua
-- Example keymaps to consider (only add what you actually need)
local map = vim.keymap.set

-- Move lines up/down in visual mode (already in LazyVim, but good to know)
-- map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
-- map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Keep cursor centered when scrolling
-- map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
-- map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })
```

---

## Phase 4: Add Custom Plugins

Create separate files in `lua/plugins/` for each concern:

### Suggested Plugin Files

| File | Purpose | When to Add |
|------|---------|-------------|
| `lua/plugins/colorscheme.lua` | Theme config | **Done!** |
| `lua/plugins/editor.lua` | Editor enhancements | Phase 3+ |
| `lua/plugins/coding.lua` | Coding-specific tools | Phase 3+ |
| `lua/plugins/ui.lua` | UI customizations | Phase 3+ |
| `lua/plugins/lang.lua` | Language-specific overrides | When needed |

### Plugin Ideas for Later

```lua
-- lua/plugins/editor.lua (example for later)
return {
  -- Better f/t motions with labels
  {
    "folke/flash.nvim",  -- Already in LazyVim, but can customize
    opts = {
      modes = {
        search = { enabled = true },  -- Use flash in / search
      },
    },
  },

  -- Undo tree visualization
  { "mbbill/undotree" },
}
```

---

## Phase 5: Advanced (Long-term)

These are for when you're genuinely comfortable with Neovim:

- **DAP (Debug Adapter Protocol)** — Debug code directly in Neovim
- **Neotest** — Run tests from within Neovim
- **Custom snippets** — LuaSnip custom snippet files
- **Harpoon** — Quick file switching (ThePrimeagen style)
- **Oil.nvim** — File management as a buffer
- **Obsidian.nvim** — If you use Obsidian for notes
- **Neogit / Diffview** — Advanced git workflows

---

## Learning Resources

### Videos
- **ThePrimeagen** — Vim motions, speed editing (YouTube)
- **TJ DeVries** — Neovim core dev, plugin development (YouTube)
- **Folke** — LazyVim creator, check his dotfiles on GitHub

### Interactive
- `vimtutor` — Terminal command, the OG tutorial
- `:Tutor` — Built-in Neovim tutorial
- [Vim Adventures](https://vim-adventures.com/) — Game-based learning
- [OpenVim](https://www.openvim.com/) — Interactive tutorial

### References
- [LazyVim Docs](https://www.lazyvim.org/) — Your distro's documentation
- [LazyVim Keymaps](https://www.lazyvim.org/keymaps) — All default keymaps
- [Neovim Docs](https://neovim.io/doc/) — Official documentation
- [Catppuccin for Neovim](https://github.com/catppuccin/nvim) — Theme customization

---

## Tips

1. **Don't over-configure early** — Learn what you need, then add it
2. **One change at a time** — Add a plugin, learn it, then add the next
3. **Use `:checkhealth`** — Diagnose issues with your setup
4. **`:Lazy`** — Manage plugins (update, clean, profile)
5. **`:Mason`** — Manage LSP servers, formatters, linters
6. **Press `<Space>` and read** — Which-key is your best friend
7. **Commit your config often** — So you can roll back experiments
