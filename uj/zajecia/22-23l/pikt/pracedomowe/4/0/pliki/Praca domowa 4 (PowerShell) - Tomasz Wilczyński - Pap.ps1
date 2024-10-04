# Ściągnij wynik wyszukiwania do pliku HTML.
Invoke-WebRequest -Uri "https://www.pap.pl/wyszukiwanie/starzenie%20si%C4%99%20spo%C5%82ecze%C5%84stwa" -OutFile "PapWyszukiwanie.html"

# Wyciągnij adresy do artykułów z zapisanego pliku wyszukiwania.
$AdresyArtykułów = Select-String -Path "PapWyszukiwanie.html" -Pattern "<h3 class=`"title`">.+</h3>" -AllMatches | ForEach-Object { $_.Matches.Value -replace "^.*href=`"(.+?)`".*","https://www.pap.pl`$1"}

# Ściągnij pierwsze 10 artykułów do plików HTML.
$AdresyArtykułów | ForEach-Object {
	if ($AdresyArtykułów.indexOf($_) -le 9) {
		Invoke-WebRequest -Uri $_ -OutFile ("PapArtykuł" + ($AdresyArtykułów.indexOf($_) + 1) + ".html")
	}
}

# Przetwórz wszystkie pliki HTML artykułów:
Get-ChildItem -Path "PapArtykuł*.html" | ForEach-Object {
	# Zapisz kod HTML pliku z artykułem do zmiennej.
	$KodArtykułu = Get-Content -Path $_

	# Połącz cały kod w jedną linię.
	$KodArtykułu = $KodArtykułu -join ""

	# Znajdź i zapisz do zmiennej tytuł artykułu i usuń z niego tagi HTML.
	$TytułArtykułu = $KodArtykułu -match "<h1 class=`"title`">.+?</h1>"
	$TytułArtykułu = $Matches[0] -replace "<.*?>",""

	# Znajdź i zapisz do zmiennej treść artykułu artykułu.
	$TreśćArtykułu = $KodArtykułu | Select-String -Pattern "<article role=`"article`".+>.+?</article>" | ForEach-Object { $_.Matches.Value }

	# Usuń podpisy zdjęć (div z klasą description), usuń specjalne spacje, usuń podpis (PAP), podziel na akapity, usuń tagi, usuń spacje na końcu, pomiń puste linie.
	$TreśćArtykułu = $TreśćArtykułu -replace "<div class=`"description`">.*</div>","" "[\u00A0]"," " -replace "\(PAP\)","" -split "<p>" -replace "<.*?>","" -replace " +$" -match "." | Select-Object -SkipLast 2

	# Zapisz tytuł i treść artykułu do pliku TXT.
	@(
		$TytułArtykułu
		$TreśćArtykułu
	) | Set-Content -Path ($_.BaseName + "-1.txt")

	# Znajdź i zapisz linie zawierające słowa kluczowe w tytule i treści artykułu do pliku TXT.
	@(
		$TytułArtykułu
		$TreśćArtykułu
	) | Select-String -Pattern "starze" | Set-Content -Path ($_.BaseName + "-2.txt")
}

Pause
