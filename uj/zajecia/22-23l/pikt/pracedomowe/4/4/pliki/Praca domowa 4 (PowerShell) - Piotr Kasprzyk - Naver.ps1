Invoke-WebRequest -Uri "https://search.naver.com/search.naver?where=news&ie=utf8&sm=nws_hty&query=%EB%B6%81%ED%95%B5" -OutFile "NaverWyszukiwanie.html"

$NaverWyszukiwanie = Get-Content -Path "NaverWyszukiwanie.html"

$OdnośnikiArtykułów = $NaverWyszukiwanie -split "<span class=.*?>" -match "<a href=`"https://n.news.naver.com/mnews/article/.+?`"" -replace "^.*전</span><a href=`"", "" -replace "`'a=nws.+nav&r=.*$", "" -replace "`" class=.*$", ""

$OdnośnikiArtykułów | ForEach-Object { 
	Invoke-WebRequest -Uri $_ -OutFile ("Naver" + ($OdnośnikiArtykułów.indexOf($_) + 1) + ".html")
}

$NaverArtykuły = Get-ChildItem -Path "naver*.html"

$NaverArtykuły | ForEach-Object {
	$Zawartość = Get-Content -Path $_

	$Tytuł = $Zawartość | Select-String -Pattern "<title>.+?</title>"
	$Tytuł = $Tytuł -replace "<.+?>", "" -replace "`t", ""

	$Treść = $Zawartość -join "" -replace "^.*<div id=`"newsct_article`".*?>", "" -replace "<div class=`"byline`">.*$", "" -split "<br>" -replace "<.+?>", "" -replace "`t", "" -match "."

	@(
		$Tytuł
		$Treść
	) | Set-Content -Path ($_.BaseName + "-1.txt")

	$Treść = $Treść | Select-String -Pattern "북핵"

	@(
		$Tytuł
		$Treść
	) | Set-Content -Path ($_.BaseName + "-2.txt")
}

Pause