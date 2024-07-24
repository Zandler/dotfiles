# Requires Powershell Version > 5 

<#
    .SYNOPSIS
    Powershell script for install and configure environemnt.
    
    .DESCRIPTION
    Requirements: 
        local admin rigths
        Set-ExecutionPolicy Unrestricted
    Secionts:
        Install some softwares such like git
        Install WSL 2
        Configure WSL with some softwares
        Configure for frontend development (nvm, docker, starship)
#>


function TestAdminRights {
    return ([Security.Principal.WindowsPrincipal] `
              [Security.Principal.WindowsIdentity]::GetCurrent() `
              ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
}
function InstallDefaultSoftware
{
    Clear-Host

    write-host "
        #######################
        #  SOFTWARES DEFAULT  #
        #######################" -ForegroundColor DarkGray
        Write-Host
        Write-Host

    $DefaultSoftwareList = "Microsoft.PowerShell.Preview", 
                    "Microsoft.WindowsTerminal",
                    "Google.Chrome",
                    "Microsoft.VisualStudioCode",
                    "Notepad++.Notepad++",
                    "Microsoft.PowerToys",
                    "7zip.7zip",
                    "Google.Chrome",
                    "JanDeDobbeleer.OhMyPosh"
                    "Git.Git"

   foreach ($Software in $DefaultSoftwareList )
   {
        Clear-Host
        write-host "Install " + $software -ForegroundColor DarkGray
        
        winget install -e --id $Software

    } 

    Install-Module Terminal-icons
    Install-Module Posh-Git
    Install-Module DockerCompletion
    Install-Module -Name PSReadLine
    
}

function InstallWsl
{
    $select = Read-Host "
I need to remove and install again (like ansible/terraform).
All your data will be lost.
Continue? (y/N)" -ForegroundColor DarkCyan

    wsl --unregister Ubuntu 

    if ($select -ne "y") {
        Exit-PSHostProcess
    }

    write-host "
WSL erased. 
Install again wsl. "
    wsl --install -d Ubuntu 
    Start-Sleep -Seconds 3
           
} 


function CheckRequirements($User, $Email)
{
    Clear-Host

    write-host "
        #######################
        #  CHECK REQUIREMENTS #
        ######################" -ForegroundColor DarkCyan
        Write-Host
        Write-Host
    
    write-host "1. Check SO" -ForegroundColor DarkCyan
    Start-Sleep -Seconds 3
    
    if($Env:OS -notlike "*Windows*")
    {
        write-host "> This is only for Microsoft Windows 11" -ForegroundColor DarkRed
    }
    
    write-host "2. Check Local admin (Admin Rigths)" -ForegroundColor DarkCyan
    Start-Sleep -Seconds 3
    
    if(!(TestAdminRights)) 
    {   
        write-host "You need to be local admin." -ForegroundColor DarkRed
            Start-Sleep -Seconds 5
            Exit
    }
    
    write-host "Check Execution Policy"
    
    if ((Get-ExecutionPolicy) -ne  "Unrestricted")
    {
        Write-Host "Not compliance."
        write-host "change to Unrestricted" -ForegroundColor DarkGray
        Start-Sleep -Seconds 3
        Set-ExecutionPolicy Unrestricted
    }
    
    write-host "3. Check Winget" -ForegroundColor DarkCyan
    Start-Sleep -Seconds 3
    try {

        winget --version 

   } catch {

        write-host "Winget not found. Installing..." - -ForegroundColor DarkRed
        $progressPreference = 'silentlyContinue'
        Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
        Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
        Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile Microsoft.UI.Xaml.2.8.x64.appx
        Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
        Add-AppxPackage Microsoft.UI.Xaml.2.8.x64.appx
        Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
   }
}

function MenuHeader($User)
{
    
    $Date = Get-Date -Format "dd/MM/yyyy HH:mm" 
    Clear-Host

    Write-Host " *************************************************" -ForegroundColor DarkBlue
    Write-Host " *   Dotfiles / Windows                          *" -ForegroundColor DarkBlue
    Write-Host " *   Author: Zandler <zandler@outlook.com>        *" -ForegroundColor DarkBlue
    Write-Host " *   Version: 0.9                                *" -ForegroundColor DarkBlue
    Write-Host " *   $($Date)                            *" -ForegroundColor DarkBlue
    Write-Host " *************************************************" -ForegroundColor DarkBlue
    Write-Host
    Write-Host
    Start-Sleep -Seconds 3
}

function Main 
{
    menuHeader  

    CheckRequirements

    InstallDefaultSoftware

    InstallWsl
    
    wsl -e ./bmg-wsl-setup.sh
}

Main 

