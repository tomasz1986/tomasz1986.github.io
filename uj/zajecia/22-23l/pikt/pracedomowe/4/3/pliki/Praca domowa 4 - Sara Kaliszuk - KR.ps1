# Poprawki:
# - usunięcie zmiennej $HOME ze ścieżek plików
# - zapisanie wszystkich adresów do zmiennej, a następnie użycie Invoke-WebRequest do wszystkich po kolei
# - faktycznie istniejące pliki do pętli zebrane są za pomocą Get-ChildItem

# Zapisujemy adresy artykułów do zmiennej.
$Adresy = @(
	"https://n.news.naver.com/mnews/article/032/0003219644?sid=102"
	"https://n.news.naver.com/mnews/article/469/0000736019?sid=104"
	"https://n.news.naver.com/mnews/article/003/0011822219?sid=104"
	"https://n.news.naver.com/mnews/article/310/0000106132?sid=104"
	"https://n.news.naver.com/mnews/article/056/0011472116?sid=104"
	"https://n.news.naver.com/mnews/article/047/0002390010?sid=100"
	"https://n.news.naver.com/mnews/article/003/0011818040?sid=102"
	"https://n.news.naver.com/mnews/article/310/0000106051?sid=102"
	"https://n.news.naver.com/mnews/article/016/0002130244?sid=104"
	"https://n.news.naver.com/mnews/article/003/0011781123?sid=102"
)

# Zapisujemy treść artykułów do plików HTML.
$Adresy | ForEach-Object {
	Invoke-WebRequest -Uri $_ -OutFile ("kr_" + ($Adresy.indexOf($_) + 1) + ".html")
}

# Tworzymy pętlę, która zadziała na 10 plikach z wyżej, nazwanych od kr_1 do kr_10;
$Files = Get-ChildItem -Path "kr_*.html"

# Dla każdego pliku ma wykonać następujące polecenia:
foreach ($File in $Files) {
	# Pobiera zawartość każdego z plików i zaznaczy elementy zawierające tekst, który nas interesuje
	$Zawartość = Get-Content -Path $File | Select-String -Pattern "<title>", "<br>"
	# i teraz usuwamy sobie wszystkie elementy, które nie są tekstem. Niestety nie umiem usunąć wszystkich, ale trudno.
	$Treść = $Zawartość -split "`t" -split "<title>" -split "</title>" -split "<br>" -split "<span.+?>.+</span>" -split "</div>.+</span>" -split "<strong>.+</strong>" -split "<s.+>.+?</span>"
	# Wysyłamy treść bez < > do nowego pliku i zamykamy pętlę.
	$Treść | Set-Content -Path ("내용_" + $File.BaseName + ".txt")
}

# W drugiej pętli działamy na nowo utworzonych plikach i zaznaczamy w nich słowo klucz, a potem wysyłamy to do nowego pliku.
$Files = Get-ChildItem -Path "내용_kr_*.txt"

foreach ($File in $Files) {
	$Klucze = Get-Content -Path $File | Select-String -Pattern "성차별"
	$Klucze | Set-Content -Path ("단어_" + $File.BaseName + ".txt")
}

Pause
