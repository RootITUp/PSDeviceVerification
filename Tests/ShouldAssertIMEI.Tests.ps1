BeforeAll {
    $manifestPath = Join-Path -Path (Join-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath "..") -ChildPath "src") -ChildPath "PSDeviceVerification.psd1" 
    Import-Module $manifestPath -Force -ErrorAction Stop
}

InModuleScope PSDeviceVerification {
    Describe "Assert-DeviceInformation" {
        Context "Given IMEI is null or empty" {
            It "Returns error if IMEI is null" {
                { Assert-DeviceInformation $null } | Should -Throw
            }
    
            It "Returns error if IMEI is empty" {
                { Assert-DeviceInformation "" } | Should -Throw
            }
        }
    
        Context "Given IMEI is invalid" {
            It "Returns invalid IMEI length error if IMEI length is less than 14" {
                $result = Assert-DeviceInformation -IMEI "1234567890123"
                $result["IMEI"]["Reason"] | Should -Be "Invalid IMEI length"
                $result["IMEI"]["Valid"] | Should -Be $false
            }
    
            It "Returns invalid IMEI length error if IMEI length is greater than 16" {
                $result = Assert-DeviceInformation -IMEI "12345678901234567"
                $result["IMEI"]["Reason"] | Should -Be "Invalid IMEI length"
                $result["IMEI"]["Valid"] | Should -Be $false
            }
    
            It "Returns invalid data error if IMEI fails Luhn algorithm check" {
                $result = Assert-DeviceInformation -IMEI "12345678901234"
                $result["IMEI"]["Reason"] | Should -Be "Invalid data. Could not be verified using Luhn algorithm. Checksum violated."
                $result["IMEI"]["Valid"] | Should -Be $false
            }
        }
    
        Context "Given IMEI is valid" {
            It "Returns valid result if IMEI is valid" {
                $result = Assert-DeviceInformation -IMEI "354715686958278"
                $result["IMEI"]["Reason"] | Should -Be ""
                $result["IMEI"]["Valid"] | Should -Be $true
            }

            It "Returns valid result if IMEI is valid" {
                $result = Assert-DeviceInformation -IMEI "358287580344381"
                $result["IMEI"]["Reason"] | Should -Be ""
                $result["IMEI"]["Valid"] | Should -Be $true
            }
    
            It "Returns data if IMEI is valid and TAC is provided" {
                # TODO: Add test for TAC validation once TAC validation is implemented.
            }
        }
    }
}