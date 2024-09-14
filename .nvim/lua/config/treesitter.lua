return {
  'nvim-treesitter/nvim-treesitter',
  built = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup({

      ensure_installed = {
        "vimdoc", "lua", "bash"
      },
      sync_install = false,
      auto_install = true,
      indent = {
        enable = true
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })
    local treesitter_parser_config = require('nvim-treesitter.parsers').get_parser_configs()
    treesitter_parser_config.powershell = {
      install_info = {
        url = "~/.config/nvim/tsparsers/tree-sitter-powershell",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "main",
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
      },
      filetype = "ps1",
    }
  end
}
