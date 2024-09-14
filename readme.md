# Windots

## Quick Installation

  <a href="https://youtube.com/watch?v=2xkyf9uLK5M">

  <img src="https://img.youtube.com/vi/2xkyf9uLK5M/maxresdefault.jpg" alt="Quick Install" width="800"/>
</a>

1. Go the the parent directory where you want the repo to exist (ex. `c:\src`)
2. Run the following command as **Administrator** in PowerShell

```PowerShell
# Clones Repo to directory and runs installer script
git clone https://github.com/Matalus/windots.git terminal-profile; cd terminal-profile; .\install.ps1
```
## Neovim Setup (LazyVim)

neovim configuration will be stored in `.\nvim-config` at the root of this repo.
A Symbolic Link is created with a target of `$env:LOCALAPPDATA\nvim` (`c:\users\<profile>\appdata\local\nvim`)
Neovim looks for it's configuration by default on windows in this directory.

### **Notable customizations**

- **COC.nvim (Conqueror of Completion)** configured to support `PowerShell` autocompletion
- **MarkdownLint** and **Markdown_Inline** configured in Mason to support live rendering in editor run `:RenderMarkdown`
- **colorschemes.lua** additional colorschemes
- **conform.nvim** setup for LSP and autoformatting `<leader>cf`
- **gitsigns.nvim** show inline diff `<leader>gp`
- **undotree**

![neovim](https://www.vectorlogo.zone/logos/neovimio/neovimio-ar21.svg)

💤 LazyVim

<a href="https://youtube.com/watch?v=TC8Mc6Y5LTo">
  <img src="https://img.youtube.com/vi/TC8Mc6Y5LTo/maxresdefault.jpg" alt="Neovim Setup" width="800"/>
</a>

## prerequisites

### Windows Terminal

![Windows Terminal](https://learn.microsoft.com/windows/terminal/images/terminal.svg)

> Installed via Scoop

# TODO automate profile configuration

### Install PowerShell 7

![powershell](https://raw.githubusercontent.com/PowerShell/PowerShell/master/assets/ps_black_128.svg?sanitize=true)

> Check winget for latest version of PowerShell
> NOTE: `install.ps1` will also attempt to automate this

```powershell
$winget = winget search --Id Microsoft.PowerShell --exact;
$PSLatest = $winget | where-object {
  $_ -match "Microsoft.PowerShell"
} | ForEach-Object { 
  $_ -split "\s+" | Select-Object -Index 2 
}
```

```powershell
Get-Command pwsh -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Version
```

## Scoop package manager
 ![scoop.sh](https://avatars.githubusercontent.com/u/16618068?s=30)

> This Project relies on **Scoop** to manage and streamline software and package dependencies

The 1st time you run `.\install.ps1` the script will check if scoop is installed, and attempt to install if not present.

if you'd like to install manually or browse for additional apps / packages visit [https://scoop.sh](https://scoop.sh/)

### scoop buckets 

> required for some 3rd party packages

- extras
- nerd-fonts
- main

### scoop packages

> Add additional packages to `scoop.yaml` to make them required

- neovim
- extras/windows-terminal
- extras/terminal-icons
- extras/posh-git
- extras/psreadline
- extras/azuredatastudio
- extras/lazygit
- nerd-fonts/FiraCode-NF
- nerd-fonts/FiraCode-NF-Mono
- nerd-fonts/Cascadia-NF
- nerd-fonts/JetBrainsMono-NF
- main/oh-my-posh
- main/diffutils
- main/7zip
- main/lua
- main/curl
- main/nmap
- main/luarocks
- main/vim
- main/nano
- main/ast-grep
- main/cacert
- main/fd
- main/fzf
- main/grep
- main/gzip
- main/micro
- main/mingw
- main/ripgrep
- main/tree-sitter
- main/wget
 
