Push-Location -LiteralPath $PSScriptRoot

Get-ChildItem -Path *.html -Recurse | ForEach-Object {
	($_ | Select-String -Pattern "<li>(\w+ )+(-|–) \p{Hangul}+").Line -replace "–","-" -replace "(<!--|-->)","" -replace "^( |\t)+","" -replace "( |\t)+$"
} | Sort-Object -Unique | Set-Content -LiteralPath "vocabulary.txt"

function End-Script {
	Pop-Location
	Break
}

End-Script
