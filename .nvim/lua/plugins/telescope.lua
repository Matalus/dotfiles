return {
  require('telescope').setup {
    defaults = {
      vimgrep_arguments = {
        'rg',
        '-L',
        '--hidden',
        '--line-number',
        '--column',
        '--smart-case',
        '--follow',         -- Follow symlinks
        '--glob', '!.git/', -- (Optional) Ignore .git directory
      },
    },
  }
}
