$Links = Invoke-WebRequest -Uri "https://search.naver.com/search.naver?where=news&ie=utf8&sm=nws_hty&query=%EC%A0%80%EC%B6%9C%EC%82%B0" | Select-Object -ExpandProperty Content | Select-String -Pattern "https://n\.news\.naver\.com/mnews/article/[^`"]*" -AllMatches | ForEach-Object {$_.Matches.Value}
#jest to czesc, ktora robilismy razem na konsultacjach, jednak wtedy wyszukiwala 10 wynikow, a teraz tylko 5 i nie rozumiem dlaczego
#https://n.news.naver.com/mnews/article/366/0000899478?sid=101; https://n.news.naver.com/mnews/article/003/0011843369?sid=104; https://n.news.naver.com/mnews/article/421/0006790182?sid=101; https://n.news.naver.com/mnews/article/011/0004187239?sid=104; https://n.news.naver.com/mnews/article/009/0005126347?sid=104

$Links | ForEach-Object {
	Invoke-WebRequest -Uri $_ | Select-Object -ExpandProperty Content | Set-Content -Path ($_.BaseName + ".txt")
#Utknelam na zapisaniu kazdego tekstu osobno. Probowalam: ($_.Matches.Value + ".html"), ($_.Basevalue + ".html"), "[1-10].html", "*.html" i szukac w internecie jak polaczyc ForEach-Object z Set-Content, ale nic nie znalazlam, wiec to co wyszukalam punktem wyzej zapisałam manualnie
}

$Html = Get-ChildItem -Path "*.html"
$Html | ForEach-Object {
	$Text = Get-Content -Path $_
	$Title = $Text | Select-String -Pattern "<title>.*</title>"
	$Cleantitle = $Title -replace "<.*?>", "" -replace "`t", "" -match "."
#W tym momencie się zgubiłam i nie mam pojęcia jak wyszczególnić akapity. Próbowałam z Select-String -Pattern "br[^p]*" i to działalo kiedy pracowalam na pojedynczym linku (chociaz niezbyt dobrze), a w tym skrypcie nie działa wcale
	$1 = $Text -join "" -replace "<head>.*</head>", " " -replace "<[^/]*", " " -replace "", " "
Pause
	$Content = $Text | Select-String -Pattern "<.*>.*</.*>"
	$Clean = $Content -replace "<.*?>", "" -replace "`t", "" -match "."
}
