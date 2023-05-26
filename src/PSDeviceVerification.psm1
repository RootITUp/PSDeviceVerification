# Dot source the files
$Private:files += Get-ChildItem -Path "$PSScriptRoot" -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue

foreach ($file in $Private:files) {
    Try {
        . $file.fullname
    }
    Catch {
        Throw "Failed to import function $($file.fullname): $_"
    }
}

#-- Strict
Set-StrictMode -Version 2.0
$Global:ErrorActionPreference = "Stop"
#--