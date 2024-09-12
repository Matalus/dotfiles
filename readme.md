# Installation (WIP)


[![Quick Install](https://img.youtube.com/vi/TC8Mc6Y5LTo/maxresdefault.jpg)](https://youtube.com/watch?v=TC8Mc6Y5LTo "Quick Install")

## Quick Installation

1. Go the the parent directory where you want the repo to exist (ex. `c:\src`)
2. Run the following command as **Administrator** in PowerShell

```PowerShell
# Clones Repo to directory and runs installer script
git clone https://github.com/Matalus/windots.git terminal-profile; cd terminal-profile; .\install.ps1
```

## prerequisites

### Install PowerShell 7

> Check winget for latest version of PowerShell

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

### install scoop

2. Check for `scoop.cmd`

```PowerShell
$scoop_installed = get-command scoop.cmd -ErrorAction SilentlyContinue
```
3. Install scoop if not scoop_installed

### scoop buckets 

> required for some 3rd party pacakges

- extras
- nerd-fonts
- main

### scoop packages

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
 
