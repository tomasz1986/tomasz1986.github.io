 Get-Content -Path "$Home/Desktop/razny/naver 2 (poprawione).html"|Set-Content -Path "$Home/naverart2.txt"
 $naver2 = Get-Content -Path "$Home/naverart2.txt"
$tag = Select-String -Path "$Home/naverart2.txt"-Pattern h[1-6]
$tag2 = Select-String -Path "$Home/naverart2.txt"-Pattern li
$tag3 = Select-String -Path "$Home/naverart2.txt"-Pattern p
$tag4 = Select-String -Path "$Home/naverart2.txt"-Pattern /p
$tag5 = Select-String -Path "$Home/naverart2.txt"-Pattern /h[1-6]
$tag6 = Select-String -Path "$Home/naverart2.txt"-Pattern /li
$wczesniej = ($tag, $tag2, $tag3, $tag4,$tag5, $tag6)
$teraz = ''
$naver21 = $naver2 -replace $wczesniej, $teraz|Set-Content -Path "$Home/naverart21.txt"
$naver22 = Get-Content -Path "$Home/naverart21.txt" | Sort-Object -Property Length
$naver22 | Set-Content -Path "$Home/naverart22.txt"