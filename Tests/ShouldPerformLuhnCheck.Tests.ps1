BeforeAll {
    $manifestPath = Join-Path -Path (Join-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath "..") -ChildPath "src") -ChildPath "PSDeviceVerification.psd1" 
    Import-Module $manifestPath -Force -ErrorAction Stop
}

Describe "Test-LuhnCheck" {
    Context "Valid Data" {
        It "Returns true for a valid credit card number with an even number of digits" {
            InModuleScope PSDeviceVerification {
                $result = Test-LuhnCheck "453275631450418"
                $result | Should -Be $true
            }
        }
      
        It "Returns true for a valid credit card number with an odd number of digits" {
            InModuleScope PSDeviceVerification {
                $result = Test-LuhnCheck "492971260134447"
                $result | Should -Be $true
            }
        }
      
        It "Returns true for a valid credit card number with spaces" {
            InModuleScope PSDeviceVerification {
                $result = Test-LuhnCheck "4929 7126 0134 4443"
                $result | Should -Be $true
            }
        }
      
        It "Returns true for a valid credit card number with hyphens" {
            InModuleScope PSDeviceVerification {
                $result = Test-LuhnCheck "4929-7126-0134-4443"
                $result | Should -Be $true
            }
        }
      
        It "Returns true for a valid IMEI number" {
            InModuleScope PSDeviceVerification {
                $result = Test-LuhnCheck "354715685169067"
                $result | Should -Be $true
            }
        }
    }
      
    Context "Invalid Data" {
        It "Returns false for an empty input" {
            InModuleScope PSDeviceVerification {
                $result = Test-LuhnCheck ""
                $result | Should -Be $false
            }
        }
      
        It "Returns false for a non-numeric input" {
            InModuleScope PSDeviceVerification {
                $result = Test-LuhnCheck "4929-7126-abcd-4442"
                $result | Should -Be $false
            }
        }
      
        It "Returns false for a credit card number with an invalid checksum" {
            InModuleScope PSDeviceVerification {
                $result = Test-LuhnCheck "492971260134443"
                $result | Should -Be $false
            }
        }
      
        It "Returns false for a credit card number with an invalid length" {
            InModuleScope PSDeviceVerification {
                $result = Test-LuhnCheck "492971260134"
                $result | Should -Be $false
            }
        }
    }
      
    Context "Edge Cases" {
        It "Returns false for a credit card number with all the same digits" {
            InModuleScope PSDeviceVerification {
                $result = Test-LuhnCheck "4444444444444444"
                $result | Should -Be $false
            }
        }
      
        It "Returns false for a credit card number with alternating digits" {
            InModuleScope PSDeviceVerification {
                $result = Test-LuhnCheck "1010101010101010"
                $result | Should -Be $false
            }
        }
      
        It "Returns true for a credit card number with the minimum valid length" {
            InModuleScope PSDeviceVerification {
                $result = Test-LuhnCheck "0"
                $result | Should -Be $true
            }
        }
    }
}