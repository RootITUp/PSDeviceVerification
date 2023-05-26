BeforeAll {
    $manifestPath = Join-Path -Path (Join-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath "..") -ChildPath "src") -ChildPath "PSDeviceVerification.psd1" 
    Import-Module $manifestPath -Force -ErrorAction Stop
}

InModuleScope PSDeviceVerification {
    Describe "Assert-DeviceInformation -MAC tests" {

        Context "Valid MAC addresses" {
    
            It "Returns valid for 00-11-22-33-44-55" {
                $result = Assert-DeviceInformation -MAC "00-11-22-33-44-55"
                $result["MAC"]["Valid"] | Should -Be $true
                $result["MAC"]["Data"] | Should -Be "00:11:22:33:44:55"
            }
    
            It "Returns valid for 00:11:22:33:44:55" {
                $result = Assert-DeviceInformation -MAC "00:11:22:33:44:55"
                $result["MAC"]["Valid"] | Should -Be $true
                $result["MAC"]["Data"] | Should -Be "00:11:22:33:44:55"
            }
    
            It "Returns valid for 001122334455" {
                $result = Assert-DeviceInformation -MAC "001122334455"
                $result["MAC"]["Valid"] | Should -Be $true
                $result["MAC"]["Data"] | Should -Be "00:11:22:33:44:55"
            }
    
            It "Returns valid for ec:28:d3:a5:13:19" {
                $result = Assert-DeviceInformation -MAC "ec:28:d3:a5:13:19"
                $result["MAC"]["Valid"] | Should -Be $true
                $result["MAC"]["Data"] | Should -Be "EC:28:D3:A5:13:19"
            }

            It "Returns valid for F8:5B:6E:B4:C9:F4" {
                $result = Assert-DeviceInformation -MAC "F8:5B:6E:B4:C9:F4"
                $result["MAC"]["Valid"] | Should -Be $true
                $result["MAC"]["Data"] | Should -Be "F8:5B:6E:B4:C9:F4"
            }
        }
    
        Context "Invalid MAC addresses" {
    
            It "Returns invalid for 00-11-22-33-44-5" {
                $result = Assert-DeviceInformation -MAC "00-11-22-33-44-5"
                $result["MAC"]["Valid"] | Should -Be $false
                $result["MAC"]["Reason"] | Should -Be "MAC address is not 12 characters long"
            }
    
            It "Returns invalid for 00-11-22-33-44-556" {
                $result = Assert-DeviceInformation -MAC "00-11-22-33-44-556"
                $result["MAC"]["Valid"] | Should -Be $false
                $result["MAC"]["Reason"] | Should -Be "MAC address is not 12 characters long"
            }
    
            It "Returns invalid for 00-11-22-33-44-5g" {
                $result = Assert-DeviceInformation -MAC "00-11-22-33-44-5g"
                $result["MAC"]["Valid"] | Should -Be $false
                $result["MAC"]["Reason"] | Should -Be "MAC address contains non-hexadecimal characters"
            }
    
            It "Returns invalid for ec:2x:d3:a5:13:19" {
                $result = Assert-DeviceInformation -MAC "ec:2x:d3:a5:13:19"
                $result["MAC"]["Valid"] | Should -Be $false
                $result["MAC"]["Reason"] | Should -Be "MAC address contains non-hexadecimal characters"
            }
    
            It "Returns invalid for 01-11-22-33-44-55" {
                $result = Assert-DeviceInformation -MAC "01-11-22-33-44-55"
                $result["MAC"]["Valid"] | Should -Be $false
                $result["MAC"]["Reason"] | Should -Be "MAC address is a multicast address"
            }
    
            It "Returns invalid for 03-11-22-33-44-55" {
                $result = Assert-DeviceInformation -MAC "03-11-22-33-44-55"
                $result["MAC"]["Valid"] | Should -Be $false
                $result["MAC"]["Reason"] | Should -Be "MAC address is a multicast address"
            }
    
            It "Returns invalid for 02-aa-bb-cc-dd-ee" {
                $result = Assert-DeviceInformation -MAC "02-aa-bb-cc-dd-ee"
                $result["MAC"]["Valid"] | Should -Be $false
                $result["MAC"]["Reason"] | Should -Be "MAC address is not a globally administered address"
            }
        }
    }
}