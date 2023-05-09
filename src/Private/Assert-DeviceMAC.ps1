function Assert-DeviceMAC {
    param(
        [Parameter(Mandatory)]
        [string]$MAC
    )

    $valid = $false
    $reason = ""

    # Remove any delimiters from the MAC address
    $data = $MAC -replace "-", ""
    $data = $data -replace ":", ""

    # 1. Check if the MAC address is 12 characters long
    if ($data.Length -ne 12) {
        $reason = "MAC address is not 12 characters long"
    }
    # 2. Check if the MAC address contains only hexadecimal digits
    elseif ($data -notmatch "^[a-fA-F0-9]+$") {
        $reason = "MAC address contains non-hexadecimal characters"
    }
    # 3. Check if the MAC address is a unicast address
    elseif ($data.Substring(0, 2) -match "01|03|05|07|09|0B") {
        $reason = "MAC address is a multicast address"
    }
    # 4. Check if the MAC address is a globally administered address
    elseif ($data.Substring(1, 1) -match "2|6|A|E") {
        $reason = "MAC address is not a globally administered address"
    }
    else {
        $valid = $true
    }

    # Create a hashtable to return the validity and the reason if it is not valid
    $result = @{
        Valid  = $valid
        Reason = $reason
        Data   = $data
    }

    if (-not $valid) {
        Write-Warning -Message ("{0} :: The MAC address {1} resulted in {2}." -f $MyInvocation.MyCommand, $data, $reason)
    }

    return $result
}
