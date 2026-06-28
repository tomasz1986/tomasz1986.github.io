$Robocopy = if ($env:robocopy) {
	$env:robocopy
} else {
	"robocopy.exe"
}

$Source = $PSScriptRoot
$Destination = Join-Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "Biuro\WWW\twilczynski.com\viiilo"
if (Test-Path -LiteralPath $Destination) {
	Invoke-Expression -Command ($Robocopy + " /mir `"" + $Source + "`" `"" + $Destination + "`" /xd `"pliki`" `"zajecia`"")
	Invoke-Expression -Command ($Robocopy + " /mir `"" + (Join-Path -Path $Source -ChildPath "pliki" | Join-Path -ChildPath "SK1A") + "`" `"" + (Join-Path -Path $Destination -ChildPath "pliki" | Join-Path -ChildPath "SK1A") + "`"")
	Invoke-Expression -Command ($Robocopy + " /mir `"" + (Join-Path -Path $Source -ChildPath "pliki" | Join-Path -ChildPath "SK1B") + "`" `"" + (Join-Path -Path $Destination -ChildPath "pliki" | Join-Path -ChildPath "SK1B") + "`"")
	Invoke-Expression -Command ($Robocopy + " /mir `"" + (Join-Path -Path $Source -ChildPath "zajecia" | Join-Path -ChildPath "24-25" | Join-Path -ChildPath "jk1") + "`" `"" + (Join-Path -Path $Destination -ChildPath "zajecia" | Join-Path -ChildPath "24-25" | Join-Path -ChildPath "jk1") + "`"")
	Invoke-Expression -Command ($Robocopy + " /mir `"" + (Join-Path -Path $Source -ChildPath "zajecia" | Join-Path -ChildPath "25-26" | Join-Path -ChildPath "jk1") + "`" `"" + (Join-Path -Path $Destination -ChildPath "zajecia" | Join-Path -ChildPath "25-26" | Join-Path -ChildPath "jk1") + "`"")
	Invoke-Expression -Command ($Robocopy + " /mir `"" + (Join-Path -Path $Source -ChildPath "zajecia" | Join-Path -ChildPath "25-26" | Join-Path -ChildPath "jk2") + "`" `"" + (Join-Path -Path $Destination -ChildPath "zajecia" | Join-Path -ChildPath "25-26" | Join-Path -ChildPath "jk2") + "`"")
}

Push-Location -LiteralPath $Destination

Invoke-Expression -Command (Join-Path -Path . -ChildPath "base-https.ps1")

Push-Location -LiteralPath ".."
Invoke-Expression -Command (Join-Path -Path . -ChildPath "github-push.cmd")
Pop-Location

Pop-Location

Pause
