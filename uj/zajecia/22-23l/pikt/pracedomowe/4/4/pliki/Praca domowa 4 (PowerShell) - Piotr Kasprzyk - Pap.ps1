Invoke-WebRequest -Uri "https://www.pap.pl/wyszukiwanie/bro%C5%84%20j%C4%85drowa%20krld" -OutFile "PapWyszukiwanie.html"

$PapWyszukiwanie = Get-Content -Path "PapWyszukiwanie.html"

$OdnośnikiArtykułów = $PapWyszukiwanie -match "<h3 class=`"title`"><a href=`"/node/[0-9]+?`">" -replace "^.*?<h3 class=`"title`"><a href=`"" -replace "`">.*$" | ForEach-Object {
	"https://www.pap.pl" + $_
}

$OdnośnikiArtykułów | ForEach-Object {
	Invoke-WebRequest -Uri $_ -OutFile ("Pap" + ($OdnośnikiArtykułów.indexOf($_) + 1) + ".html")
}

$PapArtykuły = Get-ChildItem -Path "pap*.html"

$PapArtykuły | ForEach-Object {
	$Zawartość = Get-Content -Path $_

	$Tytuł = $Zawartość -join "" -replace "^.*<h1.*?>","" -replace "</h1>.*$","" -replace "<.*?>",""

	$Treść = $Zawartość -join "" -replace "^.*<article role=`"article`".*?>","" -replace "</article>.*$","" -split "<h[1-6].*?>" -split "<p>" -split "<p .*?>" -replace "<.*?>","" -replace "^ +","" -replace " +$",""

	@(
		$Tytuł
		$Treść
	) | Set-Content -Path ($_.BaseName + "-1.txt")

	$Treść = $Treść | Select-String -Pattern "broń jądrowa","broni jądrowej","bronią jądrową"

	@(
		$Tytuł
		$Treść
	) | Set-Content -Path ($_.BaseName + "-2.txt")
}

Pause
