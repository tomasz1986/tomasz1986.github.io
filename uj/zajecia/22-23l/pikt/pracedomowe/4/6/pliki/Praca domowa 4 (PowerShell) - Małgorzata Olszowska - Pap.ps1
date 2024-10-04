$NaverWyszukiwanie = Get-ChildItem -Path "pap*.html"

$NaverWyszukiwanie | ForEach-Object {
	$Tekst = Get-Content -Path $_ | Select-String -Pattern "<p>", "</p>"

	$Tekst = $Tekst -join "" -replace "<!--.*?-->","" -replace "<p .+?>","" -replace "</p>","" -replace "`t","" -split "<.+?>" -replace " +$","" -match ".+"

	$Tekst | Set-Content -Path ($_.BaseName + ".txt")
}

#na początku zrobiłam skrypt podobnie do tego z naver news, potem po rozmowie z Kamilą, skorzystałam z jej wskazówki i dodałam przy skrypcie z PAP, Select-String [Select-String -Pattern '<div property="schema:text" class="field field--name-body field--type-text-with-summary field--label-hidden field--item">' '</div>'] żeby szybciej i lepiej wyodrębnić tekst wpisując w Pattern komendę(?) pod którą w skrypcie strony była schowana treść. Niestety nie zadziałało to do końca. Po pierwsze nie dla wszystkich plików wyskoczył plik txt na koniec, po drugie w powstałych plikach dalej jest dużo zbędnych elementów.
#Zmieniłam w Select-String -Pattern na prostszą wersję div i dodałam p, ale wyskakiwał niekończący się błąd dlatego postanowiłam przenieść Select-String w inne miejsce (do teraz był zaraz za ForEach-Object [$Tekst = Get-Content -Path $_ | Select-String -Pattern "<div .+?>", "</div>" "<p>", "</p>"]).
#Zamiana miejsca nie zadziałała ale usunięcie <div... już tak, dlatego zostawiłam jak jest.

$SlowoKlucz = Get-ChildItem -Path "*.txt"

$SlowoKlucz | ForEach-Object {
	$Zdania = Get-Content -Path $_

	$Zdania = $Tekst -match "ekstremizm"

	$Zdania | Set-Content -Path ("Zdania-pap" + ".txt")
}

Pause

#z nieznanego mi powodu część mająca wyrzucić plik txt ze zdaniami zawierającymi słowo "ekstremizm" nie działa i wyświetla false.
