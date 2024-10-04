$NaverWyszukiwanie = Get-ChildItem -Path "naver*.html"

$NaverWyszukiwanie | ForEach-Object {
	$Tekst = Get-Content -Path $_

	# Poprawka: Łączymy kod w całość, następnie usuwamy wszystko przed i po treści artykułu, a dopiero później czyścimy kod z niepotrzebnych elementów i znaków.
	# $Tekst = $Tekst -join "" -replace "<!--.*?-->","" -replace "<br>"," " -replace "<a .+?>","" -replace "</a>","" -replace "`t","" -split "<.+?>" -replace " +$","" -match ".+"
	$Tekst = $Tekst -join "" -replace "^.*<div id=`"newsct_article`".*?>","" -replace "<div class=`"byline`">.*$" -replace "`t","" -split "<br>" -replace "<.*?>","" -replace "  +"," " -replace "^ +","" -replace " +$","" -match "."

	# Korzystając ze skryptu stworzonego na konsultacjach, najpierw wybrałam pliki html (na moim laptopie zaczynałam od ustawienia w PowerShell lokalizacji (Set-Location) czego tutaj nie ma) po czy za pomocą pipeline nastąpiła próba wyciągnięcia tylko tekstu przy utworzeniu nowej zmiennej Tekst (jak widać w plikach txt nie wyszło do końca). Próbowałam przefiltrować treść, tak żeby nie wyskakiwała cała masa różnych niepotrzebych rzeczy ale każda próba kończyła się tym, że skrypt nie tworzył już w ogóle pliku txt. Moj plan to bylo skupic się na tym, że treść artykułów znajduje się w komendzie zaczynającej się <div id=newsct_article> ale wyskakują mi tylko błedy kiedy próbuję to wprowadzić (w różnych formach, z div, bez div np[-like '<id="newsct_article" .+?>']). Dlatego się poddałam z plikami naver. Na koniec, jak na konsultacjach za pomocą Set-Content powinny utworzyć sie dla każdej strony pliki txt pod tą samą nazwą.

	$Tekst | Set-Content -Path ($_.BaseName + ".txt")
}

$SlowoKlucz = Get-ChildItem -Path "*.txt"

$SlowoKlucz | ForEach-Object {
	$Zdania = Get-Content -Path $_

	# Poprawka: Wystarczy samo "극단주의", ale -match użyty samodzielnie wyświetli tylko "true" lub "false", więc lepiej użyć Select-String.
	# $Zdania = $Tekst -match ".+? 극단주의*"
	$Zdania = $Tekst | Select-String -Pattern "극단주의"

	# Poprawka: Brakowało "$_.BaseName", tak aby każdy artykuł zapisywał się do oddzielnego pliku.
	# $Zdania | Set-Content -Path ("Zdania-koreanski" + ".txt")
	$Zdania | Set-Content -Path ($_.BaseName + " zdania-koreanski" + ".txt")

	#tutaj za pomocą Get-ChildItem wybieram pliki txt po czym wyciągam z nich najpierw tekst a następnie szukam w nich, juz pod zmienna Zdania, zdań z tekstu zawierających słowo klucz. Potem podobnie do skryptu z konsultacji użyłam Set-Content żeby utworzyć plik txt z tymi zdaniami. Nie działa to jednak idealnie. Niestety nie wiem gdzie jest błąd. 
}

Pause
