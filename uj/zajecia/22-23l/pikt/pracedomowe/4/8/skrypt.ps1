$Adres = "https://artmuseum.pl/pl/kolekcja/dekady/1980"

Invoke-WebRequest -Uri $Adres -OutFile "Polska1980.html"

$Adresy = Select-String -Path "Polska1980.html" -Pattern "<li class=`"work`">"
$Adresy = $Adresy -replace "^.*<li class=`"work`"><a href=`"","" -replace "`">$","" | ForEach-Object {
	"https://artmuseum.pl" + $_
}

$Adresy | ForEach-Object {
	# Invoke-WebRequest -Uri $_ -OutFile ("Polska1980-" + ($_ -replace "^.*/","") + ".html")
}

$PlikiHtml = Get-ChildItem -Path "Polska1980-*.html"

$PlikiHtml | ForEach-Object {
	$Zawartość = Get-Content -Path $_

	$Zawartość = $Zawartość -join "" -replace "<h2>","<h2>Autor: " -replace "</h2> *?<h4>","</h2><h4>Tytuł: " -replace "^.*<h2>","" -replace "<ul class=`"share`">.*$","" -split "</h2>" -split "</h4>" -split "<br>" -replace "<.*?>","" -replace "^ +","" -replace " +$","" -match "."

	$Zawartość | Sort-Object | Set-Content -Path ($_.BaseName + ".txt")
}

Pause
