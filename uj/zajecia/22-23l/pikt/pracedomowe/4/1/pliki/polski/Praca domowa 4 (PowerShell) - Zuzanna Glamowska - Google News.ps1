# Set variables for search terms, number of articles to download, and file paths
$searchTerms = "przestępstwa narkotykowe"
$numArticles = 10
$htmlFolderPath = "C:\Users\progr\OneDrive\Pulpit\마약범죄\polski\html"
$textFolderPath = "C:\Users\progr\OneDrive\Pulpit\마약범죄\polski\nagłówki i treść"
$sentencesFolderPath = "C:\Users\progr\OneDrive\Pulpit\마약범죄\polski\zdania"

# Download HTML of the first $numArticles articles containing $searchTerms
$results = Invoke-WebRequest "https://news.google.com/search?q=$searchTerms&hl=pl&gl=PL&ceid=PL%3Apl" -UseBasicParsing
$articles = $results.Links | Where-Object {$_.class -eq "DY5T1d"}

for ($i = 0; $i -lt $numArticles; $i++) {
    $article = Invoke-WebRequest "https://news.google.com${articles[$i].href}" -UseBasicParsing
    $htmlPath = Join-Path $htmlFolderPath "html$($i+1).txt"
    $article.Content | Out-File $htmlPath
}

# Extract text from HTML and save to new files
$htmlFiles = Get-ChildItem $htmlFolderPath | Select-Object -First $numArticles
foreach ($file in $htmlFiles) {
    $textPath = Join-Path $textFolderPath "zdania$($file.BaseName.Substring(4)).txt"
    (Get-Content $file.FullName | Out-String) -split '<.*?>' | Select-String $searchTerms | Out-File $textPath
}

# Extract sentences containing $searchTerms and save to new files
$textFiles = Get-ChildItem $textFolderPath | Select-Object -First $numArticles
foreach ($file in $textFiles) {
    $sentencesPath = Join-Path $sentencesFolderPath "ostatni$($file.BaseName.Substring(6)).txt"
    (Get-Content $file.FullName) | Select-String $searchTerms | Out-File $sentencesPath
}