Push-Location -LiteralPath $PSScriptRoot

function End-Script {
	Pop-Location
	Pause
	Break
}

$Path = ($PSScriptRoot -replace "\\","/" -replace " ","%20" -replace "/[^/]+$","/")

Get-ChildItem -Path "index.html" -Recurse | ForEach-Object {
	$File = $_.FullName
	$File
	$FileContent = $_ | Get-Content -Raw
	@(
		if ($FileContent | Select-String -Pattern "<base [^>]+>") {
			$FileContent -replace"<base [^>]+>","<base href=`"file://$Path`">"
		}
	) | Set-Content -LiteralPath $File -NoNewline
}

End-Script