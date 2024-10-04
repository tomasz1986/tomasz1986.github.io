
#Pozbędzie się z plików wszystkich tagów i innych znaczników pozostawiając wyłącznie sam tytuł oraz podzielony na akapity tekst.

#Wyszuka i zapisze w oddzielnym pliku wszystkie zdania zawierające dane słowo kluczowe.

#wyszukanie hasła w Google
$Url = "https://www.pap.pl/wyszukiwanie/przemoc%20w%20szkole"
$Wyszukanie = Invoke-WebRequest $Url

#zapisanie html w zmiennej Text
$Text = $Wyszukanie.Content

#wyszukanie linków do artykułu
$Pattern = 'class="title"><a href="(.+?)"'
$Elem = $Text | Select-String  -Pattern $Pattern -AllMatches

#zapisanie linków w liście
$Linki = @()
$count = 1
While ($count -le 10){
	foreach ($Elem1 in $Elem.Matches){
		$Linki += "www.pap.pl"+$Elem1.Groups[1].Value 
		$count++
		}
}

#zapisanie html do plików pt. PAP
$Licznik = 1
foreach ($Link in $Linki) {
	$Filename = "PAP$Licznik.html"
	Invoke-WebRequest $Link -OutFile $Filename
	$Licznik++	}

