Push-Location -LiteralPath $PSScriptRoot

$Path = "https://twilczynski.com/"

Get-ChildItem -Path "index.html" -Recurse | ForEach-Object {
	$File = $_.FullName
	$File
	$FileContent = $_ | Get-Content -Raw
	@(
		if ($FileContent | Select-String -Pattern "<base [^>]+>") {
			$FileContent -replace "<base [^>]+>","<base href=`"$Path`">"
		}
	) | Set-Content -LiteralPath $File -NoNewline
}
