# Przy pomocy Get-Content wyciągamy adresy do artykułów z pliku "pap linki.txt", a następnie przy pomocy Invoke-WebRequest zapisujemy kod artykułów w postaci plików HTML.
$Licznik = 1
Get-Content -Path "pap linki.txt" | forEach-Object {
	$PlikHtml = "PAP" + $Licznik + ".html"
	if (-not (Test-Path -Path $PlikHtml -PathType Leaf)) {
		Invoke-WebRequest -Uri $_ -OutFile $PlikHtml
	}
	$Licznik++
}

# Przy pomocy Get-ChildItem znajdujemy wszystkie pliki .html w folderze, a następnie przetwarzamy je po kolei w ten sam sposób.
Get-ChildItem -Path "*.html" | ForEach-Object {
	# Przy pomocy Get-Content wyciągamy zawartość pliku, a następnie za pomocą Select-String szukamy tytułu i akapitów artykułu.
	$treśćArtykułu = Get-Content -Path $_ | Select-String -Pattern "<title>", "<p>"

	# Przy pomocy -replace usuwamy tagi HTML.
	$treśćArtykułu = $treśćArtykułu -replace "<.+?>", ""

	# Zapisujemy treść artykułu w obecnej formie w pliku z końcówką -1.txt.
	$treśćArtykułu | Out-File -FilePath ($_.BaseName + "-1.txt")

	# Przy pomocy Select-String wyszukujemy słów kluczy w treści, a następnie zapisujemy wynik końcowy w pliku z końcówką -2.txt.
	$treśćArtykułu | Select-String -Pattern "internet","cenzura","internecie","cenzury" | Out-File -FilePath ($_.BaseName + "-2.txt")
}

Pause
