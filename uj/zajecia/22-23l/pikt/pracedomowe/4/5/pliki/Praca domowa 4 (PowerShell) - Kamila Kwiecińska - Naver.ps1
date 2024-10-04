# Poprawki:
# - Pliki zebrane przez Get-ChildItem są od razu wysyłane do ForEach-Object, więc nie ma potrzeby zapisywania całości do zmiennej.
# - Dodanie operatora -match na końcu w celu zebrania jedynie niepustych linii

# W nowym skrypcie NAVERA (który bazuje na ORYGINALNYCH formach plików HTML) spróbowałam zrobić pętle do plików HTML poprzez wykorzystanie komendy Get-ChildItem | ForEach-Object. 
# W pierwszej zmiennej $Naver wykorzystałam kod Select-String -Pattern aby POWERSHELL wyszukał tylko i wyłącznie tytuł oraz treść artykułów bez zbędnych tagów nie wnoszących nic do mojej pracy domowej. 
# W kodzie Get-Content wykorzystałam zmienną $_, która używana jest w odniesieniu do pojedynczego obiektu, wysłanego przez potok.
# W Ouf-File wykorzystałam komendę z $_.BaseName, która pozwoliła mi na dodanie do podstawowej nazwy plików HTML kolejnych słów w nowopowstałych plikach .txt (tu: CAŁOŚĆ i 고령화).

Get-ChildItem -Path "Naver*.html" | ForEach-Object {
	$Naver = Get-Content -Path $_ | Select-String -Pattern "<h2 .+?>", "</h2>", "</div><em .+?>", "<br><br>"

	$Naver = $Naver -join "" -replace "<h2 .+?>","" -replace "<div .+?>","" -replace "&#8764;","-" -replace "`t","" -replace "&#039;","'" -replace "&nbsp;","" -replace "&nbsp;","" -split "<.+?>" -replace "&quot;","" -replace "&#0392023;","" -replace "&#39;","'" -match "."
	$Naver

	$Naver | Out-File -FilePath ($_.BaseName + " CAŁOŚĆ.txt")
	$Naver

	$Naver = $Naver | Select-String -Pattern "고령화" | Out-File -FilePath ($_.BaseName + " 고령화.txt")
}

Pause
