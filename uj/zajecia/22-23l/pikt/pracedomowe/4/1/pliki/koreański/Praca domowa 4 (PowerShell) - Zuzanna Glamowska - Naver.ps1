# Define the search query and the number of articles to download
$query = "마약범죄"
$num_articles = 10

# Create the directories for the downloaded files
$html_dir = "C:\Users\progr\OneDrive\Pulpit\마약범죄\koreański\html"
$text_dir = "C:\Users\progr\OneDrive\Pulpit\마약범죄\koreański\nagłówki i treść"
$sentence_dir = "C:\Users\progr\OneDrive\Pulpit\마약범죄\koreański\zdania"
New-Item -ItemType Directory -Force -Path $html_dir
New-Item -ItemType Directory -Force -Path $text_dir
New-Item -ItemType Directory -Force -Path $sentence_dir

# Download the search results and save the HTML files
$url = "https://search.naver.com/search.naver?where=news&query=$query"
$html = Invoke-WebRequest -Uri $url
$articles = $html.Links | Where-Object { $_.class -eq "news_tit" } | Select-Object -First $num_articles
for ($i=0; $i -lt $articles.Count; $i++) {
    $article_url = $articles[$i].href
    $article_html = Invoke-WebRequest -Uri $article_url
    $filename = "html$($i+1).txt"
    $filepath = Join-Path -Path $html_dir -ChildPath $filename
    $article_html.Content | Out-File -FilePath $filepath
}

# Extract the text from the HTML files and save as separate text files
Get-ChildItem -Path $html_dir -Filter *.txt | ForEach-Object {
    $filename = $_.Name -replace ".html", ".txt"
    $filepath = Join-Path -Path $text_dir -ChildPath $filename
    $article_html = Get-Content -Path $_.FullName
    $article_text = ($article_html -split "<[^>]*>" | Where-Object { $_ -match $query }) -join "`n`n"
    $article_text | Out-File -FilePath $filepath
}

# Extract the sentences containing the search phrase and save as separate text files
Get-ChildItem -Path $text_dir -Filter *.txt | ForEach-Object {
    $filename = "zdanie$($_.Name -replace "treść|\.txt", "").txt"
    $filepath = Join-Path -Path $sentence_dir -ChildPath $filename
    $article_text = Get-Content -Path $_.FullName
    $sentences = $article_text -split "\.|`n" | Where-Object { $_ -match $query }
    $sentences | Out-File -FilePath $filepath
}