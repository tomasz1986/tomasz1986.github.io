#Zapisze pierwsze 10 z nich na dysku w postaci plików HTML.

#Pozbędzie się z plików wszystkich tagów i innych znaczników pozostawiając wyłącznie sam tytuł oraz podzielony na akapity tekst.

#Wyszuka i zapisze w oddzielnym pliku wszystkie zdania zawierające dane słowo kluczowe.

$Url = "https://search.naver.com/search.naver?where=news&ie=utf8&sm=nws_hty&query=%ED%95%99%EA%B5%90%ED%8F%AD%EB%A0%A5"
$Wyszukanie = Invoke-WebRequest $Url

#zapisanie html w zmiennej Text
$Text = $Wyszukanie.Content

#wyszukanie linków do artykułu
$Pattern = '(http.{1,5}n\.news\.naver\.com.+?)".+?class="info"'
$Elem = $Text | Select-String  -Pattern $Pattern -AllMatches

#zapisanie linków w liście
$Linki = @()
foreach ($Elem1 in $Elem.Matches){
	$Linki += $Elem1.Groups[1].Value 
	}

#zapisanie html do plików pt. Naver
$Licznik = 1
foreach ($Link in $Linki) {
	$Filename = "Naver$Licznik.html"
	Invoke-WebRequest $Link -OutFile $Filename
	$Licznik++	}


$folder = Get-Location
$pliki = Get-ChildItem -Path $folder -Filter *.html
foreach ($plik in $pliki){
	$html = Get-Content $plik.FullName -Raw
	#regex dla tytułu
	$TytulReg = '<span>"(.*)"</span>'
	#regex dla textu
	$TextReg = 'img_desc">(.+)<'
	
	#wyszukanie tytułu
	if ($html -match $TytulReg) {
        $TytulMatch = [regex]::Match($html, $TytulReg)
        $Tytul = $TytulMatch.Groups[1].Value
		Write-Host $Tytul
    } else {
        $Tytul = ""
    }

	#wyszukanie tekstu
    if ($html -match $TextReg) {
        $TextMatch = [regex]::Match($html, $TextReg)
        $Text1 = $TextMatch.Groups[1].Value
		Write-Host $Text1
    } else {
        $Text1 = ""
    }

	#Zapisanie zawartości w pliku txt
	$Calosc = $Tytul + $Text1
	Write-Host $Calosc
    

    Set-Content -Path $outputPath -Value "$Tytul`r`n$Text1"
}
