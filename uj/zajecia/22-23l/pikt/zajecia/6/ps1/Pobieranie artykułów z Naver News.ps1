# Adres do poniższej zmiennej kopiujemy i wklejamy bezpośrednio z Navera. Dzięki temu możemy w wyszukiwarce ustawić, np. konkretny przedział dat, a następnie skopiować taki adres z automatycznie dodanymi parametrami, wkleić go tutaj, a skrypt wtedy użyje go do pobierania artykułów.
$AdresWyszukiwania = ""

# Używamy pętli do {} while (), tak aby skrypt automatycznie przechodził do kolejnych stron wyszukiwania i zbierał z nich adresy do artykułów. Skrypt sam zatrzyma się w momencie, gdy dojdzie do ostatniej strony wyszukiwania.
do {
	# Zapisujemy do zmiennej kod strony wyszukiwania (bez potrzeby tworzenia pliku HTML na dysku).
	$StronaWyszukiwania = Invoke-WebRequest -Uri $AdresWyszukiwania | Select-Object -ExpandProperty Content

	# Wyszukujemy w kodzie strony i zapisujemy do zmiennej wszystkie adresy głównych artykułów znajdujących się na Naver News. Użycie "+=" przy zmiennej powoduje, że do listy dodawane są kolejne adresy bez nadpisywania poprzednich.
	$AdresyArtykułów += $StronaWyszukiwania | Select-String -Pattern "<a href[^>]*class=`"info`"[^>]*>" -AllMatches | ForEach-Object {
		$_.Matches.Value -replace "^.*?`"","" -replace "`".*$","" | Select-String -Pattern "\.news\.naver\.com"
	}

	# Wyszukujemy w kodzie adresu do kolejnej strony wyszukiwania i zapisujemy go do zmiennej.
	$AdresWyszukiwania = $StronaWyszukiwania | Select-String -Pattern "<a href[^>]*class=`"btn_next`"[^>]*>" | ForEach-Object {
		"https://search.naver.com/search.naver" + ($_.Matches.Value -replace "^.*?`"","" -replace "`".*$","")
	}
} while ($AdresWyszukiwania)

# Po zebraniu wszystkich adresów pobieramy i zapisujemy je w formie plików HTML.
$AdresyArtykułów | ForEach-Object {
	Invoke-WebRequest -Uri $_ -OutFile ("Artykuł" + $AdresyArtykułów.indexOf($_) + ".html")
}

Pause
