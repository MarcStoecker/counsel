Push-Location $PSScriptRoot
claude --plugin-dir . @args
Pop-Location
