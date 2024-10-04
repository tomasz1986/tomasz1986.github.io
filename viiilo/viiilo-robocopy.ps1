$Source = $PSScriptRoot
$Destination = Join-Path $env:USERPROFILE -ChildPath "Desktop\Pulpit\Biuro\WWW\twilczynski.com\viiilo"
if (Test-Path -LiteralPath $Destination) {
	$Command = $env:robocopy + " /mir `"" + $Source + "`" `"" + $Destination + "`""
	Invoke-Expression -Command $Command
}

Pause
