return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  config = function()
    require('telescope').setup {

      defaults = {
        vimgrep_arguments = {
          'rg',
          '--no-ignore',
          '-L',
          '--hidden',
          '--line-number',
          '--column',
          '--smart-case',
          '--follow',         -- Follow symlinks
          '--glob', '!.git/', -- (Optional) Ignore .git directory
        },
      },
      pickers = {
        git_branches = {
          theme = "dropdown",
        }
      }
    }
  end,
  keys = {
    -- add a keymap to browse plugin files
    -- stylua: ignore
    {
      "<leader>fp",
      function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
      desc = "Find Plugin File",
    },
    {
      "<leader>gS",
      function() require("telescope.builtin").git_branches() end,
      desc = "Find Git Branches",
    }
  },
  -- change some options
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
    },
  },

}
