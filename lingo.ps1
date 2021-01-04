$onlineWordList = "https://raw.githubusercontent.com/RazorSh4rk/random-word-api/master/words.json"
$dictionary = (Invoke-WebRequest -Uri $onlineWordList).Content | ConvertFrom-Json

Function Write-LastGuess {
    Param (
        $targetWord,
        $lastGuess
    )
    Write-Host $lastGuess[0] -NoNewline -BackgroundColor Green -ForegroundColor Black
    for ($i=1; $i -lt $Wordlength; $i++) {
        if ($lastGuess[$i] -eq $targetWord[$i]) {
            Write-Host "|" -NoNewline
            Write-Host $lastGuess[$i] -NoNewline -BackgroundColor Green -ForegroundColor Black
        } elseif ($targetWord -match $lastGuess[$i]) {
            Write-Host "|" -NoNewline
            Write-Host $lastGuess[$i] -NoNewline -BackgroundColor Yellow -ForegroundColor Black
        } else {
            Write-Host "|" -NoNewline
            Write-Host $lastGuess[$i] -NoNewline
        }
    }
    Write-Host ""
}

Function Play-Lingo {
    Param (
        [int]$Wordlength
    )
    $targetWord = $dictionary | Where {$_.Length -eq $Wordlength} | Get-Random
    $lastGuess = $targetWord[0]
    for ($i = 1; $i -lt $Wordlength; $i++) {
        $lastGuess += "_"
    }
    while ($lastGuess -ne $targetWord) {
        Write-LastGuess -targetWord $targetWord -lastGuess $lastGuess
        $lastGuess = Read-Host -Prompt "Guess"
    }
}