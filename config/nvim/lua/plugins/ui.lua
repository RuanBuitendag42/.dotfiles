-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃  未来侍  ·  Statusline & UI Style   ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

return {
  -- Lualine: Catppuccin Macchiato + Samurai flair
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      -- Macchiato palette
      local colors = {
        rosewater = "#f4dbd6",
        flamingo = "#f0c6c6",
        pink = "#f5bde6",
        mauve = "#c6a0f6",
        red = "#ed8796",
        maroon = "#ee99a0",
        peach = "#f5a97f",
        yellow = "#eed49f",
        green = "#a6da95",
        teal = "#8bd5ca",
        sky = "#91d7e3",
        sapphire = "#7dc4e4",
        blue = "#8aadf4",
        lavender = "#b7bdf8",
        text = "#cad3f5",
        subtext1 = "#b8c0e0",
        subtext0 = "#a5adcb",
        overlay2 = "#939ab7",
        overlay1 = "#8087a2",
        overlay0 = "#6e738d",
        surface2 = "#5b6078",
        surface1 = "#494d64",
        surface0 = "#363a4f",
        base = "#24273a",
        mantle = "#1e2030",
        crust = "#181926",
      }

      -- Samurai-themed mode labels
      local mode_labels = {
        NORMAL = "侍 NORMAL",
        INSERT = "筆 INSERT",
        VISUAL = "目 VISUAL",
        ["V-LINE"] = "目 V-LINE",
        ["V-BLOCK"] = "目 V-BLOCK",
        COMMAND = "令 COMMAND",
        REPLACE = "刀 REPLACE",
        SELECT = "選 SELECT",
        TERMINAL = "端 TERMINAL",
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
              return "道 " .. os.date("%H:%M")
            end,
          },
        },
      })
    end,
  },
}
