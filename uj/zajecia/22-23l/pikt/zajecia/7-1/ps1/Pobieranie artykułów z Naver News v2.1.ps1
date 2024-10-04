# Zapisujemy do zmiennej znaki, które nie są dozwolone w nazwach plików
# w zależności od systemu plików lub systemu operacyjnego.
$NiedozwoloneZnaki = [IO.Path]::GetInvalidFileNameChars() -join ""

# Adres do poniższej zmiennej kopiujemy i wklejamy bezpośrednio z Navera. Dzięki temu możemy
# w wyszukiwarce ustawić, np. konkretny przedział dat, a następnie skopiować taki adres z automatycznie
# dodanymi parametrami, wkleić go tutaj, a skrypt wtedy użyje go do pobierania artykułów.
$AdresWyszukiwania = "https://search.naver.com/search.naver?where=news&query=%EC%9C%A0%EA%B4%80%EC%88%9C&sm=tab_opt&sort=0&photo=0&field=0&pd=3&ds=2022.01.01&de=2022.01.05&docid=&related=0&mynews=0&office_type=0&office_section_code=0&news_office_checked=&nso=so%3Ar%2Cp%3Afrom20220101to20220105&is_sug_officeid=0"

# Tworzymy folder o nazwie "Artykuły", jeśli jeszcze nie istnieje.
if (-not (Test-Path -Path "Artykuły" -PathType Container)) {
	New-Item -Path "Artykuły" -ItemType Directory
}

# Używamy pętli do {} while (), tak aby skrypt automatycznie przechodził do kolejnych stron wyszukiwania
# i zbierał z nich adresy do artykułów. Skrypt sam zatrzyma się w momencie, gdy dojdzie do ostatniej strony wyszukiwania.
do {
	# Zapisujemy do zmiennej kod strony wyszukiwania (bez potrzeby tworzenia pliku HTML na dysku).
	$AdresWyszukiwania
	$StronaWyszukiwania = Invoke-WebRequest -Uri $AdresWyszukiwania | Select-Object -ExpandProperty Content

	# Wyszukujemy w kodzie strony i zapisujemy do zmiennej wszystkie adresy głównych artykułów
	# znajdujących się na Naver News. Użycie "+=" przy zmiennej powoduje, że do listy dodawane
	# są kolejne adresy bez nadpisywania poprzednich.
	$AdresyArtykułów += $StronaWyszukiwania | Select-String -Pattern "<a href[^>]*class=`"info`"[^>]*>" -AllMatches | ForEach-Object {
		$_.Matches.Value -replace "^.*?`"","" -replace "`".*$","" | Select-String -Pattern "\.news\.naver\.com"
	}

	# Wyszukujemy w kodzie adresu do kolejnej strony wyszukiwania i zapisujemy go do zmiennej.
	$AdresWyszukiwania = $StronaWyszukiwania | Select-String -Pattern "<a href[^>]*class=`"btn_next`"[^>]*>" | ForEach-Object {
		"https://search.naver.com/search.naver" + ($_.Matches.Value -replace "^.*?`"","" -replace "`".*$","")
	}
} while ($AdresWyszukiwania)

# Zebrane adresy dzielimy na nowe linie i sortujemy jednocześnie usuwając duplikaty.
$AdresyArtykułów = $AdresyArtykułów -split "\n" | Sort-Object -Unique

# Każdy z adresów na liście pobieramy i zapisujemy do oddzielnego pliku HTML.
$AdresyArtykułów | ForEach-Object {
	# Kod każdego artykułu pobieramy, zapisujemy do zmiennej, a następnie dzielimy na nowe linie.
	$KodArtykułu = Invoke-WebRequest -Uri $_ | Select-Object -ExpandProperty Content
	$KodArtykułu = $KodArtykułu -split "\n"

	# Wyciągamy z kodu tytuł artykułu usuwając z niego tabulatory, tagi oraz zbędną treść.
	$TytułArtykułu = $KodArtykułu | Select-String -Pattern "<title"
	$TytułArtykułu = $TytułArtykułu -replace "`t","" -replace "<.*?>","" -replace " :: 네이버 TV연예",""

	# Wyciągamy z kodu artykułu datę artykułu. Format nie jest spójny i różni się w zależności od tego,
	# czy artykuł pochodzi z Naver News, Naver Entertain, Naver Sports, itp.

	# Pierwsza część kodu dotyczy Naver News.
	$DataArtykułu = $KodArtykułu -join "" | Select-String "data-date-time=`".*?`"" | ForEach-Object {
		$_.Matches.Value -replace "data-date-time=`"","" -replace " .*$","" -replace "-","."
	}
	# Druga część kodu dotyczy Naver Entertain i Naver Sports.
	if (-not $DataArtykułu) {
		$DataArtykułu = $KodArtykułu -join "" | Select-String -Pattern "기사입력.*?</span>" | ForEach-Object {
			$_.Matches.Value -replace "기사입력" -replace "^[^0-9]*" -replace "\. .*$"
		}
	}

	# Sprawdzamy, ile artykułów z taką samą datą istnieje w folderze i w przypadku przekroczenia
	# maksymalnej liczby nie zapisujemy danego artykułu.
	$MaksymalnaLiczbaArtykułów = ""
	Get-ChildItem -Path (Join-Path -Path "Artykuły" -ChildPath ("````[" + $DataArtykułu + "````] *.txt")) | Measure-Object | ForEach-Object {
		if (-not $MaksymalnaLiczbaArtykułów -or ($_.Count -lt $MaksymalnaLiczbaArtykułów)) {
			# Wyświetlamy na ekranie tytuł artykułu z datą, który pobierany jest w danym momencie.
			"[" + $DataArtykułu + "] " + $TytułArtykułu

			# Znajdujemy w kodzie artykułu fragment z jego faktyczną treścią, pozbywamy się reszty kodu,
			# a następnie usuwamy z niego zbędne elementy. Kod z treścią różni się w zależności od tego,
			# czy artykuł pochodzi z Naver News, Naver Entertain, Naver Sports, itp., stąd konieczność
			# szukania różnych tagów na początku i na końcu.
			$TreśćArtykułu = $KodArtykułu -join "" | Select-String -Pattern "<div [^>]*id=`"(articeBody|newsct_article|newsEndContents)`"[^>]*>.*?<[^ ]* class=`"(byline|source)`">"
			$TreśćArtykułu = $TreśćArtykułu | ForEach-Object {
				$_.Matches.Value
			}

			# Usuwamy tabulatory, usuwamy podpisy pod zdjęciami, usuwamy element ze źródłem,
			# zmieniamy "&quot;" na cudzysłów, dzielimy na akapity przy <br>, usuwamy tagi,
			# usuwamy spacje na początku, usuwamy spacje na końcu, zostawiamy tylko niepuste
			# linie.
			$TreśćArtykułu = $TreśćArtykułu -replace "`t","" -replace "<em class=`"img_desc`">.*?</em>","" -replace "<p class=`"source`">.*?</p>","" -replace "<script[^>]*>.*?</script>","" -replace "&quot;","`"" -split "<br>" -replace "<.*?>","" -replace "^ +","" -replace " +$","" | Select-String -Pattern "."

			# Zapisujemy tytuł oraz treść artykułu do pliku tekstowego w folderze Artykuły.
			# Z nazwy pliku usuwamy znaki, które nie są dozwolone w danym systemie plików
			# lub systemie operacyjnym. "-LiteralPath" przy "Set-Content" jest potrzebny,
			# aby można było użyć nawiasów kwadratowych w ścieżce.
			@(
				$TytułArtykułu
				$TreśćArtykułu
			) | Set-Content -LiteralPath (Join-Path -Path "Artykuły" -ChildPath ("[" + $DataArtykułu + "] " + ($TytułArtykułu -replace "[${NiedozwoloneZnaki}]","") + ".txt"))
		}
	}
}

Pause
