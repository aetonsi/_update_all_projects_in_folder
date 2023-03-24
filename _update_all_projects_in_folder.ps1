#!/usr/bin/env pwsh

Param(
    [Parameter(Mandatory = $false)] [string] $dir = $null
)

Import-Module -Scope Local "$PSScriptRoot\pwsh__Io\Io.psm1" -Force


function confirmAll([string] $dir) {
    $title = "Updating every project in folder $dir"
    $question = 'Do you want run all update commands without confirmation?'
    $choices = '&Yes', '&No'

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    return $decision -eq 0
}
function confirm([string] $dir, [string] $command) {
    $title = $dir
    $question = "Running: $command"
    $choices = '&Yes', '&No'

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    return $decision -eq 0
}

$dir = if ($dir) { $dir } else { Get-FolderBrowserDialog $PWD }
$dir = if ($dir) { $dir } else { $PWD }
$dir = Resolve-Path $dir
Write-Host "Projects folder = $dir"
$globalConfirmation = confirmAll $dir

Get-ChildItem $dir -Directory | ForEach-Object {
    Push-Location $_.FullName
    Write-Warning "================== Dir: $_"
    if (Test-Path '.svn') {
        if ($globalConfirmation -or (confirm $_.Name 'svn update')) {
            Write-Warning 'RUNNING svn update'
            & svn update --verbose
        }
    }
    if (Test-Path '.git') {
        if ($globalConfirmation -or (confirm $_.Name 'git pull')) {
            $gitargs = 'pull --progress --verbose' -split ' '
            Write-Output "RUNNING git $gitargs"
            & git @gitargs
        }
    }
    if (Test-Path '.gitmodules') {
        if ($globalConfirmation -or (confirm $_.Name 'git submodule update --recursive --remote')) {
            $gitargs = 'submodule update --progress --init --recursive --verbose' -split ' '
            Write-Output "RUNNING git $gitargs"
            & git @gitargs
        }
    }
    Pop-Location
}


Read-Host 'Completed. Press any key to continue'