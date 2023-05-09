function Test-LuhnCheck {
    param(
        [ValidateNotNull()]
        [String]
        $Data
    )

    # Strip hyphens and spaces
    $Data = $Data -replace "-", ""
    $Data = $Data -replace " ", ""

    if ([string]::IsNullOrWhiteSpace($Data)) {
        Write-Warning -Message ("{0} :: Provided empty data for luhn check." -f $MyInvocation.MyCommand)
        return $false
    }

    [regex] $digitCheck = "^[0-9]*$"
    if (-not $digitCheck.IsMatch($Data)) {
        Write-Warning -Message ("{0} :: Provided invalid, non numeric data '{1}' for luhn check." -f $MyInvocation.MyCommand, $Data)
        return $false
    }

    # Implementation of : https://de.wikipedia.org/wiki/Luhn-Algorithmus
    $sum = 0
    $parity = $Data.Length % 2

    for ($i = 0; $i -lt $Data.Length; $i++) {
        $digit = [int]::Parse($Data[$i])
        
        # Double every other digit (starting from last digit)
        if ($i % 2 -eq $parity) {
            $digit *= 2
            if ($digit -gt 9) {
                $digit = $digit - 9
            }
        }

        $sum += $digit
    }

    return ($sum % 10) -eq 0
}