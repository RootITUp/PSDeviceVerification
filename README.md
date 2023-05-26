# PSDeviceVerification 
The PSDeviceVerification module provides a simple way of verifying basic device data like MAC addresses and IMEIs. The goal of this module would be to ensure syntactic **and semantic** validity of device data for automation processes.

## Installation

```powershell
Install-Module PSDeviceVerification
```

## Basic Usage

```powershell
> result = Assert-DeviceInformation -MAC "001122334455" -IMEI "1234567890123"
```

```powershell
> $result["IMEI"]

Name                           Value
----                           -----
Valid                          False
Data                           1234567890123
Reason                         Invalid IMEI length

> $result["MAC"]

Name                           Value
----                           -----
Valid                          True
Data                           00:11:22:33:44:55
Reason
```

## Test
The repository uses Pester tests for ensuring its functionality.

```powershell
Invoke-Pester
```

## Authors

- **Torben Soennecken**
