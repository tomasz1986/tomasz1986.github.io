$Robocopy = if ($env:robocopy) {
	$env:robocopy
} else {
	"robocopy.exe"
}

$Source = $PSScriptRoot
$Destination = Join-Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "Biuro\WWW\twilczynski.com\viiilo"
if (Test-Path -LiteralPath $Destination) {
	$Command = $Robocopy + " /mir `"" + $Source + "`" `"" + $Destination + "`""
	Invoke-Expression -Command $Command
}

Push-Location -LiteralPath $Destination

Invoke-Expression -Command (Join-Path -Path . -ChildPath "base-https.ps1")

Push-Location -LiteralPath ".."
Invoke-Expression -Command (Join-Path -Path . -ChildPath "github-push.cmd")
Pop-Location

Pop-Location

Pause
