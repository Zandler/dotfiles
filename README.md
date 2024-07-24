# DOTFILES


## WINDOWS / MAC / GNU/Linux


This script works only in Windows 11 + WSL 2


# Before using, please, read all files. 


## USAGE

Execute this command:
```powershell

    . { iwr -Uri "teste.com" -Outfile bmg-powershell-setup.ps1 } | iex; bmg-powershell-setup.ps1 

```

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))