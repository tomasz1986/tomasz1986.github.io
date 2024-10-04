Invoke-WebRequest -Uri "https://n.news.naver.com/mnews/article/003/0011840534?sid=102"| Set-Content -Path $Home/naver1.txt
Invoke-WebRequest -Uri "https://n.news.naver.com/mnews/article/001/0013921320?sid=102"| Set-Content -Path $Home/naver2.txt
Invoke-WebRequest -Uri "https://n.news.naver.com/mnews/article/079/0003766773?sid=102"| Set-Content -Path $Home/naver3.txt
Invoke-WebRequest -Uri "https://n.news.naver.com/mnews/article/029/0002798800?sid=100"| Set-Content -Path $Home/naver4.txt
Invoke-WebRequest -Uri "https://n.news.naver.com/mnews/article/088/0000812413?sid=004"| Set-Content -Path $Home/naver5.txt
Invoke-WebRequest -Uri "https://n.news.naver.com/mnews/article/056/0011479274?sid=101"| Set-Content -Path $Home/naver6.txt
Invoke-WebRequest -Uri "https://n.news.naver.com/mnews/article/421/0006780027?sid=102"| Set-Content -Path $Home/naver7.txt
Invoke-WebRequest -Uri "https://n.news.naver.com/mnews/article/001/0013919848?sid=102"| Set-Content -Path $Home/naver8.txt
Invoke-WebRequest -Uri "https://n.news.naver.com/mnews/article/001/0013913428?sid=104"| Set-Content -Path $Home/naver9.txt
Invoke-WebRequest -Uri "https://n.news.naver.com/mnews/article/003/0011836643?sid=102"| Set-Content -Path $Home/naver10.txt


$Pliki = Get-ChildItem -Path "naver.?.txt"
$PlikiHtml | forEach-Object {
	$Plik = Get-ChildItem -Path $HOME | Select-String -Pattern "<.*title.*>.*<.*/title>", "<.*p>.*<.*/p.*>", "</em></span>.*<br><br>", "<br><br>.*<br><br>"| Set-Content -Path $HOME -Value $plik}
$PlikiHtml | forEach-Object {
	$Plik = -replace "<?.*?>", "" | Set-Content -Path $HOME -Value $plik}
$naverhaslo = Get-ChildItem -Path "naver.?.txt"
$hasla | forEach-Object {
	$naverhaslo -match '(?:^|\W)다문화(?:$|\W)' | Set-Content -Path $Home/naverhaslo1?.txt}
