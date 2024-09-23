# Windots

## One-Line Installation

> Clean installation on VirtualBox Windows 11 Dev OVA

  <a href="https://youtube.com/watch?v=DykhkRQmmyw">

  <img src="https://img.youtube.com/vi/DykhkRQmmyw/maxresdefault.jpg" alt="One-Line Install" width="800"/>
</a>

> [!TIP]
> Ok.. technically a 3-liner if you don't have `git` and `pwsh` installed
> 
> If you encounter errors during installation, try running the script again in a new terminal instance
>
> Some errors related to module and assembly version conflicts are often resolved by restarting the terminal

1. Ensure that `pwsh` and `git` are installed

```PowerShell
winget install --id Microsoft.PowerShell --exact;
winget install --ig Git.Git --exact;

```

2. Go the the parent directory where you want the repo to exist (ex. `c:\src`)
3. Run the following command as **Administrator** in PowerShell

```PowerShell
# Clones Repo to directory and runs installer script
git clone https://github.com/Matalus/dotfiles.git terminal-profile; cd terminal-profile; .\install.ps1
```
 
## Install Script
> [!IMPORTANT]
> Script is idempotent, just run again to check for scoop updates etc (future update maybe incorporated into profile)

### Features

- config defaults `defaults.yaml`

```yaml
nerd_font: FiraCode Nerd Font Mono # This will be the primary Nerd Font used
fallback_font: CaskaydiaCove NF # This will be used as a fallback where applicable
posh_prompt: half-life # Run Get-PoshThemes to see all possible themes
default_terminal: pwsh # Name of default Windows Terminal Profile
home_dir: c:\src
```

- Symbolic links to keep all config in repo root (created by `install.ps1`)

```yaml
symlinks:
# Neovim
- name: neovim config
  source: .nvim
  target: $env:LOCALAPPDATA\nvim
  # PowerShell profiles
- name: Windows Powershell Shim Profile
  source: .ps5shim
  target: $PS5TempProfile
- name: PowerShell 7 Profile
  source: .psprofile
  target: $PS7TempProfile
  ```

- Shim Profile for Windows Powershell (5.1)
rather than maintaining 2 separate profiles, a shim profile will run when you launch **Windows Powershell** that will automatically run your **pwsh** (7.x) profile `.ps5shim/profile.ps1`.  Some features won't run for 5.1 based on the variable `$PSCore` that checks the version

```PowerShell
# Shim profile, points to Unified PSCore Profile
$DirContext = $pwd # Get Current Directory to revert to when complete

# Get PS7 Profile Path
$PSCoreProfile = & "pwsh.exe" -NoProfile -Command '$PROFILE.CurrentUserAllHosts'

Set-Location $(split-path -parent $PSCoreProfile)
& $PSCoreProfile # Run PSCore Profile

# Revert to former working directory after unified profile script runs
Set-Location $DirContext
```

- Windows Terminal Profile Patching
Will attempt to locate and patch the Windows Terminal `settings.json` to include preferred default terminal profiles as well as making sure they all have the same **Nerd Font** configured.

- Oh-My-Posh (default **half-life** theme) change in `defaults.yaml`
- PSReadline Customization (based on [SamplePSReadLineProfile.ps1](https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1))
- [Terminal-Icons](https://github.com/devblackops/Terminal-Icons)
- Automatic Update Checks

  > [!WARNING]
  > *updates available*

  <img src="img/profile_needs_update.jpg" height="200">

  > [!NOTE]
  > *up to date*

  <img src="img/profile_up_to_date.jpg" height="60">

- `bat` (visual version of `cat` with syntax highlighting)

  <img src="img/bat.jpg" height="300">

- `delta` (enhanced diff viewer, inline highlights)

  <img src="img/delta.jpg" height="250">



## Neovim Setup (LazyVim)

neovim configuration will be stored in `.\.nvim` at the root of this repo.
A Symbolic Link is created with a target of `$env:LOCALAPPDATA\nvim` (`c:\users\<profile>\appdata\local\nvim`)
Neovim looks for it's configuration by default on windows in this directory.

![neovim](img/nvim.jpg)

### **Notable customizations**

<!-- - **COC.nvim (Conqueror of Completion)** configured to support `PowerShell` autocompletion -->
- powershell_es configured using nvim-lspconfig and conform.nvim
- **MarkdownLint** and **Markdown_Inline** configured in Mason to support live rendering in editor run `:RenderMarkdown`
- **colorschemes.lua** additional colorschemes
- **conform.nvim** setup for LSP and autoformatting `<leader>cf`
- **gitsigns.nvim** show inline diff `<leader>gp`
- **vim-fugitive**
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

### Install PowerShell 7

![powershell](https://raw.githubusercontent.com/PowerShell/PowerShell/master/assets/ps_black_128.svg?sanitize=true)

>[!IMPORTANT]
> Check winget for latest version of PowerShell (WIP)
> 
> `install.ps1` will also attempt to automate this, might replace the default builtin function

Method for getting latest version of powershell from winget

*manually*

```powershell
winget install --id Microsoft.PowerShell --exact;
winget install --ig Git.Git --exact;

```

*programmatically*

```powershell
# Profile Module Function\
# Invoked when running .\Install.ps1
Update-PowerShellCore
```

## Git Config

recommended git global configuration

```powershell
# edit git profile
git config --global -e
```

```git
[user]
  email = <email@domain.com>
  name = <Name>
  username = <UserName>
[credential]
  helper = C:/Users/<User>/AppData/Local/Programs/Git\\ Credential\\ Manager/git-credential-manager-core.exe
[init]
  defaultBranch = main
[mergetool "nvim"]
  cmd = nvim -f -c \"Gdiffsplit!\" \"$MERGED\"
[merge]
  tool = "nvimdiff -f"
[mergetool]
  prompt = false
[core]
  editor = "nvim -f"
  pager = "delta"
[safe]
  directory = *
[delta "interactive"]
  keep-plus-minus-markers = true
```

## Scoop package manager

 ![scoop.sh](https://avatars.githubusercontent.com/u/16618068?s=30)

> [!NOTE]
> This Project relies on **Scoop** to manage and streamline software and package dependencies

The 1st time you run `.\install.ps1` the script will check if scoop is installed, and attempt to install if not present.

if you'd like to install manually or browse for additional apps / packages visit [https://scoop.sh](https://scoop.sh/)

### scoop buckets 

> required for some 3rd party packages

- extras
- nerd-fonts
- main

### scoop packages
> [!IMPORTANT]
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
- main/delta
- main/bat
