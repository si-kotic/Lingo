[CmdLetBinding()]
$onlineWordList = "https://raw.githubusercontent.com/RazorSh4rk/random-word-api/master/words.json"
$dictionary = (Invoke-WebRequest -Uri $onlineWordList).Content | ConvertFrom-Json

Function Write-OneLine {
    Param (
        $targetWord,
        $lastGuess,
        $Wordlength
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

Function Write-Grid {
    Param (
        $targetWord,
        $Wordlength,
        [array]$pastGuesses
    )
    Clear-Host
    for ($j=0; $j -lt 6; $j++) {
        Write-Verbose "Last Guess = $($pastGuesses[$j])"
        if ($pastGuesses[$j]) {
            Write-OneLine -targetWord $targetWord -lastGuess $pastGuesses[$j] -Wordlength $Wordlength
        } else {
            Write-OneLine -targetWord $targetWord -lastGuess $initGuess -Wordlength $Wordlength
        }
    }
}

Function Play-Lingo {
    Param (
        [int]$Wordlength
    )
    $targetWord = $dictionary | Where {$_.Length -eq $Wordlength} | Get-Random
    $initGuess = $targetWord[0]
    for ($i = 1; $i -lt $Wordlength; $i++) {
        $initGuess += "_"
    }
    $pastGuesses = @()
    while ($pastGuesses.count -lt 6 -and $lastGuess -ne $targetWord) {
        Write-Grid -targetWord $targetWord -Wordlength $Wordlength -pastGuesses $pastGuesses
        $lastGuess = Read-Host -Prompt "Guess"
        $pastGuesses += $lastGuess
    }
    Write-Grid -targetWord $targetWord -Wordlength $Wordlength -pastGuesses $pastGuesses
    if ($pastGuesses[-1] -eq $targetWord) {
        # Write-LastGuess -targetWord $targetWord -lastGuess $lastGuess
        Write-Host "Congratulations!"
    } else {
        Write-Host "Unlucky. Better luck next time"
        Write-Host "The word you were looking for was '$targetWord'"
    }
    $repeat = Read-Host -Prompt "Would you like to play again? [y/n]"
    if ($repeat -eq "y") {
        Play-Lingo -Wordlength $Wordlength
    } else {
        Write-Host "Goodbye"
    }
}