<#PSScriptInfo

.VERSION 1.0.1

.GUID 9f5d6b05-5812-4a11-9c9b-8a46285b8652

.AUTHOR James Ruland

.COMPANYNAME US. Department of Health and Human Services

.EXTERNALMODULEDEPENDENCIES

#>
<#

.DESCRIPTION
This function retrieves a list of installed applications on a remote computer.

.PARAMETER ComputerName
The name of the computer to query.
Defaults to the local computer.

.PARAMETER NameRegex
A regular expression to filter the results by application name.
Defaults to an empty string.

#>

function Get-InstalledApps
{
    #region Parameters
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string[]]$ComputerName = $env:COMPUTERNAME,
        [string]$NameRegex = ''
    )

    #endregion Parameters

    # Iterate over each computer.
    foreach ($comp in $ComputerName)
    {
        $keys = '', '\Wow6432Node'

        # Iterate over each registry key.
        foreach ($key in $keys)
        {
            try
            {
                $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $comp)
                $apps = $reg.OpenSubKey("SOFTWARE$key\Microsoft\Windows\CurrentVersion\Uninstall").GetSubKeyNames()
            }
            catch
            {
                continue
            }

            # Iterate over each application.
            foreach ($app in $apps)
            {
                $program = $reg.OpenSubKey("SOFTWARE$key\Microsoft\Windows\CurrentVersion\Uninstall\$app")
                $name = $program.GetValue('DisplayName')
                if ($name -and $name -match $NameRegex)
                {
                    [pscustomobject]@{
                        ComputerName    = $comp
                        DisplayName     = $name
                        DisplayVersion  = $program.GetValue('DisplayVersion')
                        Publisher       = $program.GetValue('Publisher')
                        InstallDate     = $program.GetValue('InstallDate')
                        UninstallString = $program.GetValue('UninstallString')
                        Bits            = $(if ($key -eq '\Wow6432Node') {'64'} else {'32'})
                        Path            = $program.name
                    }
                }
            }
        }
    }
}