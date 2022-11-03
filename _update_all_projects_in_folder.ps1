Param(
    [Parameter(Mandatory = $false)] [string] $dir = $(resolve-path "$PSScriptRoot\..")
)


function confirmAll([string] $dir) {
    $title = "Updating every project in folder $dir"
    $question = "Do you want run all update commands without confirmation?"
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

Write-Host "Projects folder = $dir"
$globalConfirmation = confirmAll $dir

Get-ChildItem $dir -Directory | ForEach-Object {
    Push-Location $_.FullName
    Write-Output "================== Dir: $_"
    if (Test-Path '.svn') {
        if ($globalConfirmation -or (confirm $_.Name "svn update")) {
            Write-Warning "RUNNING svn update"
            & svn update
        }
    }
    if (Test-Path '.git') {
        if ($globalConfirmation -or (confirm $_.Name "git pull")) {
            Write-Warning "RUNNING git pull"
            & git pull
        }
    }
    if (Test-Path '.gitmodules') {
        if ($globalConfirmation -or (confirm $_.Name "git submodule update --recursive --remote")) {
            Write-Warning "RUNNING git submodule update --recursive --remote"
            & git submodule update --recursive --remote
        }
    }
    Pop-Location
}


Read-Host "Completed. Press any key to continue"