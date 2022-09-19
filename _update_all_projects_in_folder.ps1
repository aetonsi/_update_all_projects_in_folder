function confirmAll() {
    $title = ""
    $question = "Do you want run all commands without confirmation?"
    $choices = '&Yes', '&No'

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    return $decision -eq 0
}
function confirm([string] $dir, [string] $command) {
    $title = $dir
    $question = "Do you want to run: $command"
    $choices = '&Yes', '&No'

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    return $decision -eq 0
}


$dir = "$PSScriptRoot\.."
$globalConfirmation = confirmAll
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

