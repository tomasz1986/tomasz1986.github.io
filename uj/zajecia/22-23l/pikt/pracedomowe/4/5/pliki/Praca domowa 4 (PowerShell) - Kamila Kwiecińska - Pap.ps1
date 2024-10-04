# Poprawki:
# - Pliki zebrane przez Get-ChildItem są od razu wysyłane do ForEach-Object, więc nie ma potrzeby zapisywania całości do zmiennej.
# - Dodanie operatora -match na końcu w celu zebrania jedynie niepustych linii
# - Połączenie kodu w jedną linię, a następnie usunięcie wszystkiego przed i po elemencie <article role="article">

# W skrypcie PAP spróbowałam zrobić pętle do plików HTML poprzez wykorzystanie komendy Get-ChildItem | ForEach-Object. Wpisałam następnie kody, których użyłam w przypadku skryptu NAVERA, tzn. -split "<.+?>" do podzielenia tekstu na akapity oraz -replace do usunięcia bądź zamienienia niepotrzebnych tagów.
# W kodzie Get-Content wykorzystałam zmienną $_, która używana jest w odniesieniu do pojedynczego obiektu, wysłanego przez potok.
# W Out-File wykorzystałam komendę z $_.BaseName, która pozwoliła mi na dodanie do podstawowej nazwy plików HTML kolejnych słów w nowopowstałych plikach .txt (tu: CAŁOŚĆ i starzenie się sp).
# W niektórych artykułach pierwszy akapit rozpoczyna się od wcięcia w tekście - próbowałam go usunąć przy wykorzystaniu komendy, np. -replace "`t" (o ile jest to poprawny kod), jednak nic nie działało, dlatego postanowiłam to zostawić i zapytać Pana Doktora o to przy okazji następnych zajęć.
# Nie jestem także pewna, dlaczego przy użyciu komendy Select-String -Pattern "starzenie się społeczeństwa", powershell wyszukuje akapity, które zawierają dane słowa kluczowe, a nie tylko jedno zdanie - do tego także nie potrafiłam dojść. 

Get-ChildItem -Path "PAP*.html" | ForEach-Object {
	$Pap = Get-Content -Path $_
	$Pap = $Pap -join "" -replace "^.*<article role=`"article`".*?>","" -replace "</article>.*$","" -replace "<div .+?>","" -split "<.+?>" -replace "<.+?>","" -replace "`t",""
	$Pap

	$Pap | Out-File -FilePath ($_.BaseName + " CAŁOŚĆ.txt")
	$Pap

	$Pap = $Pap | Select-String -Pattern "starzenie się społeczeństwa" | Out-File -FilePath ($_.BaseName + " starzenie się sp.txt")
}

Pause
