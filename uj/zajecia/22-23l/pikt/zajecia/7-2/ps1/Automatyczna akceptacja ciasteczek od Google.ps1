$AdresStronyGoogle  = "https://translate.google.com/?hl=en&sl=auto&tl=en&text=%EB%8C%80%ED%95%9C%EB%AF%BC%EA%B5%AD&op=translate"
$AdresDomenyConsent = "consent.google.com"
# Aktualny UserAgent można znaleźć np. na stronie https://whatismybrowser.com/guides/the-latest-user-agent/chrome.
$UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"

# Jeśli otrzymamy odpowiedź z $AdresDomenyConsent, to zapisujemy ciasteczka
# do zmiennej $GoogleSession.
$Response = Invoke-WebRequest -Uri $AdresStronyGoogle -SessionVariable "GoogleSession" -UserAgent $UserAgent -ErrorAction Stop

# Za pomocą BaseResponse znajdujemy host, który nam odpowiedział.
$ResponseRequestUri = $Response.BaseResponse.RequestMessage.RequestUri

# Sprawdzamy, czy zostaliśmy przekierowani do $AdresDomenyConsent.
if ($ResponseRequestUri.Host -eq $AdresDomenyConsent) {
	# Obiekt otrzymany za pomocą Invoke-WebRequest nie wyświetla danych jako "form",
	# więc musimy ręcznie wyciągnąć je z "content". Strona zawiera dwa elementy <form>,
	# ale nam potrzebny jest tylko ten dla metody "POST".
	$FormContent = [regex]::Match(
		$Response.Content,
		("{0}.+?(?:{1}.+?{2}|{2}.+?{1}).+?{3}" -f
			[regex]::Escape("<form"),
			[regex]::Escape("action=`"https://" + $AdresDomenyConsent),
			[regex]::Escape("method=`"POST`""),
			[regex]::Escape("</form>")
		)
	)

	# Wyciągamy POST URL z przetworzonych danych form.
	$PostUrl = [regex]::Match($FormContent, "(?<=action\=\`")[^\`"]+(?=\`")").Value

	# Budujemy POST body jako hashtable z przetworzonych danych. Potrzebujemy
	# tylko elementów z atrybutem "name" ze zwykłymi nazwami i wartościami.
	$PostBody = @{}
	[regex]::Matches($FormContent -replace "\r?\n", "<input[^>]+>").Value | ForEach-Object {
		$Name  = [regex]::Match($_, "(?<=name\=\`")[^\`"]+(?=\`")").Value
		$Value = [regex]::Match($_, "(?<=value\=\`")[^\`"]+(?=\`")").Value

		if (-not ([string]::IsNullOrWhiteSpace($Name))) {
			$PostBody[[string]$Name] = [string]$Value
		}
	}

	# now let's try to get an accepted CONSENT cookie by POSTing our hashtable to the parsed URL and override the sessionVariable again.
	# Using the previous session variable here would return a HTTP error 400 ("method not allowed")
	$Response = Invoke-WebRequest -Uri $PostUrl -Method Post -SessionVariable "GoogleSession" -UserAgent $UserAgent -Body $PostBody -ErrorAction Stop

	# Zbieramy wszystkie ciasteczka z domeny Google'a.
	$CiasteczkaGoogle = [object[]]$GoogleSession.Cookies.GetCookies("https://google.com")

	# check if we got the relevant cookie "CONSENT" with a "yes+" prefix in its value
	# if the value changes in future, we have to adapt the condition here accordingly
	$CiasteczkoConsent = [object[]]($CiasteczkaGoogle | Where-Object { $_.Name -eq "CONSENT" })
	if (-not ($CiasteczkoConsent.Count)) {
		Write-Error -Message "Ciasteczko `"CONSENT`" nie zostało zapisane w sesji po użyciu POST!" -ErrorAction Stop

	} elseif (-not ($CiasteczkoConsent.Value -like "YES+*").Count) {
		Write-Error -Message ("Wartość ciasteczka `"CONSENT`" (`"$($CiasteczkoConsent.Value -join '" OR "')"") nie zaczyna się od ""YES+"", ale możliwe, że jest to zamierzone i należy uaktualnić kod!") -ErrorAction Stop
	}
}

# Od tej chwili możemy pobierać strony Google dodając parametr "-WebSession $GoogleSession"
# do polecenia "Invoke-WebRequest".
Invoke-WebRequest $AdresStronyGoogle -WebSession $GoogleSession -OutFile "google.html"
