# Ściągnij wynik wyszukiwania do pliku HTML.
Invoke-WebRequest -Uri "https://search.naver.com/search.naver?where=news&ie=utf8&sm=nws_hty&query=%EA%B3%A0%EB%A0%B9%ED%99%94" -OutFile "NaverWyszukiwanie.html"

# Wyciągnij adresy do artykułów z zapisanego pliku wyszukiwania.
$AdresyArtykułów = Select-String -Path "NaverWyszukiwanie.html" -Pattern "https://n.news.naver.com/mnews/article/[^`"]*" -AllMatches | ForEach-Object { $_.Matches.Value }

# Ściągnij pierwsze 10 artykułów do plików HTML.
$AdresyArtykułów | ForEach-Object {
	if ($AdresyArtykułów.indexOf($_) -le 9) {
		Invoke-WebRequest -Uri $_ -OutFile ("NaverArtykuł" + ($AdresyArtykułów.indexOf($_) + 1) + ".html")
	}
}

# Przetwórz wszystkie pliki HTML artykułów:
Get-ChildItem -Path "NaverArtykuł*.html" | ForEach-Object {
	# Zapisz kod HTML pliku z artykułem do zmiennej.
	$KodArtykułu = Get-Content -Path $_

	# Znajdź i zapisz do zmiennej tytuł artykułu i usuń z niego tagi HTML.
	$TytułArtykułu = $KodArtykułu | Select-String -Pattern "<title>.+</title>"
	$TytułArtykułu = $TytułArtykułu -replace "`t","" -replace "<.*?>",""

	# Znajdź i zapisz do zmiennej treść artykułu artykułu.
	$TreśćArtykułu = $KodArtykułu -Join "" | Select-String -Pattern "<div id=`"newsct_article`".*?<div class=`"byline`">" | ForEach-Object { $_.Matches.Value }

	# Usuń tabulatory, podziel na akapity usuwając <br>, usuń tagi HTML, usuń specjalne spacje, usuń spacje na początku, usuń spacje na końcu, pomiń puste linie.
	$TreśćArtykułu = $TreśćArtykułu -replace "`t","" -split "<br>" -replace "<.*?>","" -replace "\u3000+"," " -replace "^ +","" -replace " +$","" -match "."

	# Zapisz tytuł i treść artykułu do pliku TXT.
	@(
		$TytułArtykułu
		$TreśćArtykułu
	) | Set-Content -Path ($_.BaseName + "-1.txt")

	# Znajdź i zapisz linie zawierające słowa kluczowe w tytule i treści artykułu do pliku TXT.
	@(
		$TytułArtykułu
		$TreśćArtykułu
	) | Select-String -Pattern "고령화" | Set-Content -Path ($_.BaseName + "-2.txt")
}

Pause
