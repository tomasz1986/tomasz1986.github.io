$NaverInflacja = Get-ChildItem -Path "naver*.html"

$NaverInflacja | ForEach-Object {
	$Zawartość = Get-Content -Path $_

	$Tytuł = $Zawartość | Select-String -Pattern "<title>.+?</title>"
	$Tytuł = $Tytuł -replace "<.+?>","" -replace "`t",""

	$Treść = $Zawartość -join "" -replace "^.*<div id=`"newsct_article`".*?>" -replace "<div class=`"byline`">.*$" -split "<br>" -replace "<.+?>","" -replace "`t","" -match "."

	@(
		$Tytuł
		$Treść
	) | Set-Content -Path ($_.BaseName + "-1.txt")

	$Treść = $Treść | Select-String -Pattern "물가 {0,1}상승"

	@(
		$Tytuł
		$Treść
	) | Set-Content -Path ($_.BaseName + "-2.txt")
}

Pause
