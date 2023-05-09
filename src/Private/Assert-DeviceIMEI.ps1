function Assert-DeviceIMEI {
    param(
        [Parameter(Mandatory)]
        [string]
        $IMEI
    )

    # Strip hyphens and spaces
    $data = $IMEI -replace "-", ""
    $data = $data -replace " ", ""

    # Step 1: Check the length of the IMEI number
    if ($data.Length -lt 14 -or $data.Length -gt 16) {
        $reason = "Invalid IMEI length"

        Write-Warning -Message ("{0} :: The IMEI {1} resulted in {2}." -f $MyInvocation.MyCommand, $data, $reason)

        return @{
            "Valid"  = $false
            "Reason" = $reason
            "Data"   = $data
        }
    }

    # Step 2: Verify the check digit
    $luhnCheck = Test-LuhnCheck -Data $IMEI

    if (-not $luhnCheck) {
        $reason = "Invalid data. Could not be verified using Luhn algorithm. Checksum violated."

        Write-Warning -Message ("{0} :: The IMEI {1} resulted in {2}" -f $MyInvocation.MyCommand, $IMEI, $reason)

        return @{
            "Valid"  = $false
            "Reason" = $reason
            "Data"   = $data
        }
    }

    # Step 3: Validate the type allocation code (TAC)
    # TODO : Add if required, this requires an API access.

    return @{
        "Valid"  = $true
        "Reason" = ""
        "Data"   = $data
    }
}