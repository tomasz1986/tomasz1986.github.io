# Ustawienie zmiennej z adresem URL dla wyszukiwania Google News
$url = "https://www.google.com/search?q=konflikt+pokoleń+site:pap.pl&source=lnms&tbm=nws"

# Ustawienie zmiennej z adresem folderu docelowego
$outputFolder = "C:\Users\48512\Desktop\STUDIA\Studia nad Koreą\programowanko\pliki\7 maja artykuły"

# Ustawienie zmiennej z liczbą artykułów do pobrania
$numArticles = 10

# Tworzenie nowego obiektu GoogleChrome.Application
$ie = New-Object -ComObject "GoogleChrome.Application"

# Ustawienie właściwości obiektu GoogleChrome.Application
$ie.Visible = $false

# Przejście do strony Google News z wynikami wyszukiwania
$ie.Navigate($url)

# Oczekiwanie na załadowanie strony
while ($ie.Busy) { Start-Sleep -Milliseconds 100 }
Start-Sleep -Milliseconds 100

# Pobranie linków do artykułów z pierwszych 10 wyników wyszukiwania
$links = $ie.Document.getElementsByTagName("h3") | Where-Object { $_.className -eq "r" } | Select-Object -First $numArticles | ForEach-Object { $_.getElementsByTagName("a") | Select-Object -First 1 }

# Pobranie treści artykułów i zapis do plików HTML i TXT
foreach ($link in $links) {
    $title = $link.innerText
    $ieArticle = New-Object -ComObject "GoogleChrome.Application"
    $ieArticle.Visible = $false
    $ieArticle.Navigate($link.href)
    while ($ieArticle.Busy) { Start-Sleep -Milliseconds 100 }
    Start-Sleep -Milliseconds 100
    $filename = "$outputFolder\$title.html"
    $ieArticle.Document.body.outerHTML | Out-File -FilePath $filename -Encoding utf8
    $filename = "$outputFolder\$title.txt"
    $ieArticle.Document.getElementsByTagName("p") | ForEach-Object { $_.innerText } | Out-File -FilePath $filename -Encoding utf8
    $ieArticle.Quit()
}
# Zmiana zawartości plików na same tytuły i tekst
Get-ChildItem $outputFolder -Filter *.html | ForEach-Object {
    $html = Get-Content $_.FullName -Raw
    $document = New-Object -ComObject "HTMLFile"
    $document.IHTMLDocument2_write($html)
    $title = $document.Title
    $text = $document.Body.innerText
    $text = $text -replace '\r?\n', ' '
    $text = $text -replace '\s{2,}', "`r`n"
    Set-Content $_.FullName -Value "$title`r`n$text"

# Wyszukiwanie zdań zawierających słowo kluczowe i zapis do plików
$keyword = "konflikt pokoleń"
Get-ChildItem $outputFolder -Filter *.html | ForEach-Object {
    $filename = [System.IO.Path]::ChangeExtension($_.FullName, ".txt")
    $content = Get-Content $_.FullName -Raw
    $sentences = $content -split '[.?!]' | Where-Object { $_ -match $keyword }
$sentences | Out-File -FilePath $filename
}

# Zamknięcie obiektu "GoogleChrome.Application"
$ie.Quit()