# Poprawki:
# - jeden skrypt dla wszystkich plików HTML zamiast trzech oddzielnych
# - zapis zmiennych przy użyciu PascalCase
# - dodanie pauzy na końcu

$PlikiHtml = Get-ChildItem -Path "*.html"

$PlikiHtml = ForEach-Object {
	Get-Content -Path $_ | Set-Content -Path "$Home/pap3.txt"
	$pap3 = Get-Content -Path "$Home/pap3.txt"
	$tag = Select-String -Path "$Home/naverart2.txt"-Pattern h[1-6]
	$tag2 = Select-String -Path "$Home/naverart2.txt"-Pattern li
	$tag3 = Select-String -Path "$Home/naverart2.txt"-Pattern p
	$tag4 = Select-String -Path "$Home/naverart2.txt"-Pattern /p
	$tag5 = Select-String -Path "$Home/naverart2.txt"-Pattern /h[1-6]
	$tag6 = Select-String -Path "$Home/naverart2.txt"-Pattern /li
	$wczesniej = ($tag, $tag2, $tag3, $tag4,$tag5, $tag6)
	$teraz = ''
	$pap31 = $pap3 -replace $wczesniej, $teraz|Set-Content -Path "$Home/pap31.txt"
	$pap32 = Get-Content -Path "$Home/pap31.txt" | Sort-Object -Property Length
	$pap32 | Set-Content -Path "$Home/naverart32.txt"
}

Pause
