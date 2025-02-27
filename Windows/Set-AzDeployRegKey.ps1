<#PSScriptInfo

.VERSION 1.0.2

.GUID 11ba4566-6e08-4a1c-bddf-e67ca046721a

.AUTHOR James Ruland

.COMPANYNAME US Department of Health and Human Services

#>
function Set-AzDeployRegKey
{
    <#
        .DESCRIPTION
        Sets a registry key to indicate the status of an application or setting during an automated server deployment.

        .PARAMETER AppName
        Required. A string value for the name of the application to be installed.

        .PARAMETER RegKeyPath
        The path where the registry property will be set.

        .PARAMETER InstallValue
        The value of the new item property.
        Defaults to "true."

        .PARAMETER DeploymentType
        The type of deployment. Can be 'App' or 'Setting.' Used to set the base Registry Path if RegKeyPath is not provided.

        .EXAMPLE
        Set-AzDeployRegKey -AppName "CrowdStrike Falcon Sensor" -InstallValue "false" -DeploymentType "App"
    #>

    #region Parameters

    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]$AppName,

        [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true)]
        [string]$RegKeyPath,

        [Parameter(Mandatory = $false, Position = 2)]
        [string]$InstallValue = "true",

        [Parameter(Mandatory = $false, Position = 3)]
        [ValidateSet ('App', 'Setting')]
        [string]$DeploymentType = "App"
    )
    #endregion Parameters

    #region Variables

    # Deterine the registry path based on the DeploymentType.
    if (-not $RegKeyPath -or $RegKeyPath -eq "")
    {
        # Set the registry path based on the DeploymentType.
        switch ($DeploymentType)
        {
            'App' { $RegKeyPath = '' }
            'Setting' { $RegKeyPath = '' }
        }
    }

    #endregion Variables

    #region Main

    # Test registry path and create if not present.
    if (Test-Path $RegKeyPath)
    {
        # Check if the registry key is present.
        Write-Information "Registry Key for Logging present. Setting Key Property."
        New-ItemProperty -Path $RegKeyPath -Name $AppName
    }
    else
    {
        # Create the registry key.
        Write-Information "Registry Key for Logging not available. Creating Item $RegKeyPath"
        New-Item -Path $RegKeyPath -Force
        Write-Information "Setting Key Property."
        New-ItemProperty -Path $RegKeyPath -Name $AppName -Value $InstallValue
    }

    #endregion Main
}
