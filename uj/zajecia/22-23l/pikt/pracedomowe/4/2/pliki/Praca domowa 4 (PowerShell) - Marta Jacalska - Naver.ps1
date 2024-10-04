# Przy pomocy Get-Content wyciągamy adresy do artykułów z pliku "naver linki.txt", następnie przy pomocy Invoke-WebRequest zapisujemy kod artykułów w postaci plików HTML.
$Licznik = 1
Get-Content -Path "naver linki.txt" | forEach-Object {
	$PlikHtml = "Naver" + $Licznik + ".html"
	if (-not (Test-Path -Path $PlikHtml -PathType Leaf)) {
		Invoke-WebRequest -Uri $_ -OutFile $PlikHtml
	}
	$Licznik++
}

# Przy pomocy Get-ChildItem znajdujemy wszystkie pliki .html w folderze, a następnie przetwarzamy je po kolei w ten sam sposób.
Get-ChildItem -Path "*.html" | ForEach-Object {
	# Przy pomocy Get-Content wyciągamy zawartość pliku.
	$treśćArtykułu = Get-Content -Path $_

	# Przy pomocy -join scalamy cały kod do jednej linii, nastepnie przy pomocy -replace usuwamy zbędne elementy z klasami "media_end_summary" i "img_desc", następnie przy pomocy -replace wydzielamy linie z tytułem i treścią artykułu, a następnie za pomocą -split dzielimy kod wg nowych linii.
	$treśćArtykułu = $treśćArtykułu -join "" -replace "<strong class=`"media_end_summary`">.*?</strong>","" -replace "<em class=`"img_desc`">.*?</em>","" -replace "<h2 id=`"title_area`"","`r`n<h2 id=`"title_area`"" -replace "</h2>","</h2>`r`n" -replace "<div id=`"newsct_article`"","`r`n<div id=`"newsct_article`"" -replace "<div class=`"byline`">","`r`n<div class=`"byline`">" -split "`r`n"

	# Przy pomocy Select-String szukamy linii z tytułem i treścią artykułu.
	$treśćArtykułu = $treśćArtykułu | Select-String -Pattern "title_area","newsct_article"

	# Przy pomocy -replace usuwamy tabulatory, następnie dzielimy tekst na nowe linii przy <br> (jednym lub więcej ze spacjami po sobie), następnie usuwamy tagi HTML, a następnie za pomocą -split dzielimy kod wg nowych linii.
	$treśćArtykułu = $treśćArtykułu -replace "`t","" -replace "(<br>){1,} *","`r`n" -replace "<.+?>","" -split "`r`n"

	# Zapisujemy treść artykułu w obecnej formie w pliku z końcówką -1.txt.
	$treśćArtykułu | Out-File -FilePath ($_.BaseName + "-1.txt")

	# Przy pomocy Select-String wyszukujemy słów kluczy w treści, a następnie zapisujemy wynik końcowy w pliku z końcówką -2.txt.
	$treśćArtykułu | Select-String -Pattern "인터넷","검열" | Out-File -FilePath ($_.BaseName + "-2.txt")
}

Pause
