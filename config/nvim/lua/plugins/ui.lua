-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃  🌸  ·  Statusline & UI Style       ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

return {
  -- Lualine: Catppuccin Macchiato + Sakura flair
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      -- Sakura-themed mode labels
      local mode_labels = {
        NORMAL = "🌸 NORMAL",
        INSERT = "✎ INSERT",
        VISUAL = "◉ VISUAL",
        ["V-LINE"] = "◉ V-LINE",
        ["V-BLOCK"] = "◉ V-BLOCK",
        COMMAND = "⛩ COMMAND",
        REPLACE = "⟳ REPLACE",
        SELECT = "❀ SELECT",
        TERMINAL = "❯ TERMINAL",
      }

      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        theme = "catppuccin",
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      })

      opts.sections = vim.tbl_deep_extend("force", opts.sections or {}, {
        lualine_a = {
          {
            "mode",
            fmt = function(mode)
              return mode_labels[mode] or mode
            end,
          },
        },
        lualine_z = {
          {
            function()
              return "花 " .. os.date("%H:%M")
            end,
          },
        },
      })
    end,
  },
}
