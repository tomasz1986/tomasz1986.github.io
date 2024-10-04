$Robocopy = if ($env:robocopy) {
	$env:robocopy
} else {
	"robocopy.exe"
}

$Source = $PSScriptRoot
$Destination = Join-Path $env:USERPROFILE -ChildPath "Desktop\Pulpit\Biuro\WWW\twilczynski.com\viiilo"
if (Test-Path -LiteralPath $Destination) {
	$Command = $Robocopy + " /mir `"" + $Source + "`" `"" + $Destination + "`""
	Invoke-Expression -Command $Command
}

Pause
