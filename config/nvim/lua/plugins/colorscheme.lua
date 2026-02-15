return {
  -- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  -- ┃  Catppuccin Macchiato - THE theme for this setup ┃
  -- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "macchiato",
      background = {
        light = "latte",
        dark = "macchiato",
      },
      transparent_background = false,
      term_colors = true,
      dim_inactive = {
        enabled = true, -- Dim unfocused windows — keeps focus sharp like a blade
        shade = "dark",
        percentage = 0.15,
      },
      styles = {
        comments = { "italic" }, -- Elegant italic comments
        conditionals = { "italic" },
        keywords = { "bold" }, -- Bold keywords stand out
        functions = {},
        strings = {},
        variables = {},
      },
      integrations = {
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        noice = true,
        notify = true,
        nvimtree = true,
        semantic_tokens = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
      },
      custom_highlights = function(colors)
        return {
          -- Floating windows with subtle border glow
          FloatBorder = { fg = colors.mauve, bg = colors.mantle },
          NormalFloat = { bg = colors.mantle },

          -- Telescope styling
          TelescopeBorder = { fg = colors.mauve, bg = colors.mantle },
          TelescopePromptBorder = { fg = colors.mauve, bg = colors.mantle },
          TelescopePromptTitle = { fg = colors.crust, bg = colors.mauve, style = { "bold" } },
          TelescopeResultsTitle = { fg = colors.crust, bg = colors.teal, style = { "bold" } },
          TelescopePreviewTitle = { fg = colors.crust, bg = colors.green, style = { "bold" } },

          -- Cursor line with subtle highlight
          CursorLine = { bg = colors.surface0 },
          CursorLineNr = { fg = colors.mauve, style = { "bold" } },

          -- Color column as subtle guide
          ColorColumn = { bg = colors.surface0 },

          -- Which-key styling
          WhichKeyBorder = { fg = colors.mauve, bg = colors.mantle },
        }
      end,
    },
  },

  -- Set Catppuccin Macchiato as the LazyVim colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
