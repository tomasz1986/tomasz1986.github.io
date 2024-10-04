$Links = Invoke-WebRequest -Uri "https://www.polsatnews.pl/wyszukiwarka/?text=niski+wskaznik+urodzen" | Select-Object -ExpandProperty Content | Select-String -Pattern "https://www.polsatnews.pl/wiadomosc/[^`"]*" -AllMatches | ForEach-Object {$_.Matches.Value}
#tak jak wspominal Pan na konsultacjach, szukanie art w google konczylo sie blokiem tekstu o niczym, wiec zdecydowalam sie na polsat news - byl to pierwszy portal z newsami na ktory weszlam, ktory mial opcje lupy
#https://www.polsatnews.pl/wiadomosc/2021-03-16/kobiety-w-ciazy-bardziej-narazone-na-ciezki-przebieg-covid-19/, https://www.polsatnews.pl/wiadomosc/2021-03-08/stany-zjednoczone-liczba-urodzin-spadnie-nawet-o-300-tysiecy-wszystko-przez-pandemie/, https://www.polsatnews.pl/wiadomosc/2016-02-09/rafalska-projekt-500-to-systemowe-i-przelomowe-rozwiazanie-polityki-rodzinnej-opozycja-to-wsparcie-dla-wybranych-nie-da-pozadanych-efektow/
$Links | ForEach-Object {
	Invoke-WebRequest -Uri $_ | Select-Object -ExpandProperty Content | Set-Content -Path ($_.BaseName + "[0-10]" + ".html")
}
$Html = Get-ChildItem -Path "*.html"
$Html | ForEach-Object {
	$Text = Get-Content -Path $_
	$Title = $Text | Select-String -Pattern "<title>.*</title>"
	#Ze względu na dosc prosty kod (<title></...> i <article></...>), próbowalam usunac po kolei wszystko co niepotrzebne, ale nie dziłało:
	#$Text -replace "<!.*title>", " " -replace "</title>.*<article>"}
	$CleanTitle = $Title -replace "<.*?>", "" -replace "`t", "" -match "."
	$Article = $Text | Select-String -Pattern "<article>.*</article>"
	$CleanArticle = $Article -replace "<.*?>", "" -replace "`t", "" -match "."
}
