#--Init
$Private:public = @()
$Private:private = @()
$Private:classes = @()
#-

#Load assemblies
$Private:binaries += Get-ChildItem -Path "$PSScriptRoot\bin\" -Filter *.dll -Recurse -ErrorAction SilentlyContinue
foreach ($binary in $Private:binaries) {
    try { Add-Type -Path $binary.FullName }catch { Write-Warning -Message "Failed to load $binary" }
}

$Private:public += Get-ChildItem -Path "$PSScriptRoot\public\" -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue
$Private:private += Get-ChildItem -Path "$PSScriptRoot\private\" -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue
$Private:classes += Get-ChildItem -Path "$PSScriptRoot\classes\" -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue

#Dot source the files
foreach ($import in @($Private:public + $Private:private + $Private:classes)) {
    Try {
        . $import.fullname
    }
    Catch {
        Throw "Failed to import function $($import.fullname): $_"
    }
}

##Only Export Public Functions
Export-ModuleMember -Function $Public.Basename
Export-ModuleMember -Function $classes.Basename

#-- Strict
Set-StrictMode -Version 2.0
$Global:ErrorActionPreference = "Stop"
#--