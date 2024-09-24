# DOTFILES



## Description

After format many times windows with wsl i create this two scripts (windows and linux bootstrap). They config all first things in my enviroment. Must someone has better than me, but this, at now solve my problem.



## Before using, please, read all two scripts. 

### This script purge  wsl Ubuntu environment. 


## Requirements
Windows 11 with local administrator
Ubuntu  22.04 

## USAGE

First, you need to set execution policy in powershell.

Execute this command:
```powershell

    Set-ExecutionPolicy Unrestricted

```
**If you cannot change, please check if you has admin local**

this script do: 

- Config Terminal
- install some tools like vscode, powershell preview
- Oh-my-posh and configure theme
- Wsl2 (Ubuntu LTS)\

You can execute opne powershell terminal e paste this command: 

```powershell

iwr -Uri "https://raw.githubusercontent.com/Zandler/dotfiles/refs/heads/main/bootstrap-windows.ps1" -OutFile bootstrap-windows.ps1; .\bootstrap-windows.ps1 

```


After config powershell environment, start wsl and execute this command:

```bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Zandler/dotfiles/refs/heads/main/bootstrap-ubuntu.sh)"

```

Things inside this script:
- Update system
- Install some softwares lik httpie, poetry etc... 
- Install and configure NVM with node LTS 
- Install terminal spacheship and configure theme 
- Install docker 


