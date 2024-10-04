# Ustawienie zmiennej z adresem URL dla wyszukiwania artykułów w 네이버 뉴스
$url = "https://search.naver.com/search.naver?where=news&query=세대갈등"

# Ustawienie zmiennej z adresem folderu docelowego
$outputFolder = "C:\Users\48512\Desktop\STUDIA\Studia nad Koreą\programowanko\pliki\7 maja artykuły"

# Ustawienie zmiennej z liczbą artykułów do pobrania
$numArticles = 10

# Tworzenie nowego obiektu InternetExplorer.Application
$ie = New-Object -ComObject "InternetExplorer.Application"

# Ustawienie właściwości obiektu InternetExplorer.Application
$ie.Visible = $false

# Przejście do strony 네이버 뉴스 z wynikami wyszukiwania
$ie.Navigate($url)

# Oczekiwanie na załadowanie strony
while ($ie.Busy) { Start-Sleep -Milliseconds 100 }
Start-Sleep -Milliseconds 100

# Pobranie linków do artykułów z pierwszych 10 wyników wyszukiwania
$links = $ie.Document.getElementsByTagName("a") | Where-Object { $_.className -eq "_sp_each_url" } | Select-Object -First $numArticles

# Pobranie treści artykułów i zapis do plików HTML i TXT
foreach ($link in $links) {
    $title = $link.innerText
    $ieArticle = New-Object -ComObject "InternetExplorer.Application"
    $ieArticle.Visible = $false
    $ieArticle.Navigate($link.href)
    while ($ieArticle.Busy) { Start-Sleep -Milliseconds 100 }
    Start-Sleep -Milliseconds 100
    $filename = "$outputFolder\$title.html"
    $ieArticle.Document.body.outerHTML | Out-File -FilePath $filename -Encoding utf8
    $filename = "$outputFolder\$title.txt"
    $text = $ieArticle.Document.getElementsByTagName("p") | ForEach-Object { $_.innerText } | Out-String
    $text = $text -replace '<.*?>', ''
    $text = $text -replace '\r?\n', ' '
    $text = $text -replace '\s{2,}', "`r`n"
    Set-Content $filename -Value "$title`r`n$text"
    $ieArticle.Quit()
}

# Wyszukiwanie zdań zawierających słowo kluczowe i zapis do plików
$keyword = "세대갈등"
Get-ChildItem $outputFolder -Filter *.html | ForEach-Object {
    $filename = [System.IO.Path]::ChangeExtension($_.FullName, ".txt")
    $content = Get-Content $_.FullName -Raw
    $sentences = $content -split '[.?!]' | Where-Object { $_ -match $keyword }
    $sentences | Out-File -FilePath $filename
}

# Zamknięcie obiektu "InternetExplorer.Application"
$ie.Quit()