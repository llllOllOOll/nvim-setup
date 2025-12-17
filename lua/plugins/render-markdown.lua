return {
  "MeanderingProgrammer/render-markdown.nvim",
  cmd = { "RenderMarkdown", "RenderMarkdownToggle", "RenderMarkdownEnable", "RenderMarkdownDisable" },
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
  config = function()
    require("render-markdown").setup({
      -- Add any configuration options here
      enabled = false, -- Start disabled
      max_file_size = 1024 * 1024, -- 1MB
      render_modes = { "n", "c" },
      anti_conceal = { enabled = true },
      heading = {
        sign = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      code = {
        sign = true,
        style = "full",
        position = "right",
        language_pad = 2,
      },
      dash = {
        enabled = true,
        icon = "─",
      },
      bullet = {
        icons = { "●", "○", "◆", "◇" },
      },
      quote = {
        icon = "┃",
        repeat_linebreak = false,
      },
      checkbox = {
        checked = { icon = "󰱒 " },
        unchecked = { icon = "󰄱 " },
      },
      pipe_table = {
        padding = 1,
        use_virt_lines = true,
      },
      callout = {
        note = { icon = "󰋽 ", raw = "[!NOTE]" },
        tip = { icon = "󰌶 ", raw = "[!TIP]" },
        important = { icon = "󰅾 ", raw = "[!IMPORTANT]" },
        warning = { icon = "󰀪 ", raw = "[!WARNING]" },
        caution = { icon = "󰳦 ", raw = "[!CAUTION]" },
      },
      link = {
        image = "󰥶 ",
        email = "󰀓 ",
        hyperlink = "󰌹 ",
        highlight = "RenderMarkdownLink",
      },
      sign = {
        enabled = true,
        highlight = "RenderMarkdownSign",
      },
    })
  end,
}