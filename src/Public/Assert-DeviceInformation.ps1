function Assert-DeviceInformation {
    param(
        [ValidateNotNullOrEmpty()]
        [String]
        $IMEI,
        [ValidateNotNullOrEmpty()]
        [String]
        $MAC
    )

    $result = @{}

    if (-not [string]::IsNullOrWhiteSpace($IMEI)) {
        $result["IMEI"] = Assert-DeviceIMEI -IMEI $IMEI
    }

    if (-not [string]::IsNullOrWhiteSpace($MAC)) {
        $result["MAC"] = Assert-DeviceMAC -MAC $MAC
    }

    return $result
}