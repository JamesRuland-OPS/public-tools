<#PSScriptInfo

.VERSION 1.0.1

.GUID 31959d34-2e1a-4028-9aa4-0ce5b77c124a

.AUTHOR James Ruland

.COMPANYNAME US. Department of Health and Human Services
#>
<#

.DESCRIPTION
This function is used to incriment a letter using a conversion to ASCII.

#>
function New-IncrimentLetter
{
    #region Parameters

    [CmdletBinding(DefaultParameterSetName = "__AllParameterSets")]
    PARAM
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ $_.Length -eq 1 })]
        [char]$letter
    )

    #endregion Parameters

    # Convert the letter to ASCII.
    $asciiValue = [int][char]$letter

    #Incriment the ASCII Value.
    $asciiValue++

    # Convert the ASCII Value back to a character.
    $newLetter = [char]$asciiValue

    # Print the new character.
    $newLetter
}