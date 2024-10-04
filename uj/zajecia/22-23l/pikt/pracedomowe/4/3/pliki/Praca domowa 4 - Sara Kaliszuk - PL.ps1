# Poprawki:
# - usunięcie zmiennej $HOME ze ścieżek plików
# - zapisanie wszystkich adresów do zmiennej, a następnie użycie Invoke-WebRequest do wszystkich po kolei
# - faktycznie istniejące pliki do pętli zebrane są za pomocą Get-ChildItem

# Zapisujemy adresy artykułów do zmiennej.
$Adresy = @(
	"https://samorzad.pap.pl/kategoria/akademia-uniwersytetu-lodzkiego/czym-jest-feminizacja-ubostwa-i-jak-z-nia-walczyc"
	"https://zdrowie.pap.pl/byc-zdrowym/choc-w-zawodach-medycznych-dominuja-kobiety-nadal-mezczyzni-rzadza"
	"https://samorzad.pap.pl/kategoria/aktualnosci/kilkanascie-samorzadow-podpisalo-europejska-karte-rownosci-kobiet-i-mezczyzn"
	"https://samorzad.pap.pl/kategoria/praca/plan-rownosci-plci-w-stolecznych-urzedach"
	"https://europapnews.pap.pl/analiza-propagowanie-rownosci-kobiet-i-mezczyzn-przez-unie-europejska"
	"https://www.pap.pl/mediaroom/1453006%2Craport-basf-polska-w-sektorze-chemicznym-nadal-widoczne-roznice-w-zarobkach-i"
	"https://www.pap.pl/aktualnosci/news%2C1514207%2Cklotnia-w-przyszlym-rzadzie-izraela-poszlo-o-spolecznosc-lgbtq.html"
	"https://europapnews.pap.pl/roberta-metsola-trzecia-kobieta-na-czele-pe"
	"https://www.pap.pl/mediaroom/1546299%2Cgieldowy-dzwon-bije-w-sprawie-rownouprawnienia-kobiet.html"
	"https://www.pap.pl/aktualnosci/news%2C1549617%2Cmalzonki-prezydentow-polski-i-czech-rozmawialy-o-dzialalnosci-spolecznej-i"
)

# Zapisujemy treść artykułów do plików HTML.
$Adresy | ForEach-Object {
	Invoke-WebRequest -Uri $_ -OutFile ("pl_" + ($Adresy.indexOf($_) + 1) + ".html")
}

# Tworzymy pętlę, która zadziała na 10 plikach z wyżej, nazwanych od kr_1 do kr_10.
$Files = Get-ChildItem -Path "pl_*.html"

# Dla każdego pliku ma wykonać następujące polecenia:
foreach ($File in $Files) {
	# Pobiera zawartość plików z wyżej określonego zakresu plików i zaznacza elementy, które zawierają właściwy tekst wewnątrz.
	$Zawartość = Get-Content -Path $File | Select-String -Pattern "<title>", "<p>", "<br>", "<article>", "</title>", "<br.+>"
	# i teraz usuwa całą masę znaczników, które występują w plikach i zostawia czysty tekst.
	$Treść = $Zawartość -split "`t" -split "<title>" -split "</title>" -split "<p>" -split "</p>" -split "<div.+>" -split "<article>" -split "<br.+>"  -split "<a.+?>" -split "</a>" -split "<strong>" -split "</strong.+>" -split "</strong>" -split "<img.+>" -split "<em>" -split "</em>" -split "<span.+>.+</span>" -split "<button.+>.+</button>" -split "<iframe.+>.+</iframe>" -split "<h2.+>.+<br>"
	# Czysty tekst ląduje w nowym pliku txt, po czym zamykamy pętlę.
	$Treść | Set-Content -Path ("tekst_" + $File.BaseName + ".txt")
}

# W nowej pętli postępujemy analogicznie jak wyżej, ale działamy na nowoutworzonych plikach txt.
$Files = Get-ChildItem -Path "tekst_pl_*.txt"

foreach ($File in $Files) {
	# Pobieramy zawartość plików txt i zaznaczamy wyłącznie słowa klucze, a potem wysyłamy paragrafy do nowego pliku txt. Nie umiem zrobić tak, żeby było tylko po jednym zdaniu niestety :(
	$Klucze = Get-Content -Path $File | Select-String -Pattern "dyskryminacji", "dyskryminację", "dyskryminacją", "dyskryminacja", "płciowa", "płciowej", "płciową"
	$Klucze | Set-Content -Path ("klucze_" + $File.BaseName + ".txt")
}

Pause
