return {
  -- Catppuccin Macchiato - THE theme for this setup
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
