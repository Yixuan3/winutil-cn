function Get-WinUtilInstallLocation {
    <#
    .SYNOPSIS
        Looks up the optional custom install location for a winget package.

    .DESCRIPTION
        Searches the applications catalog for an entry whose winget id matches
        $WingetId and returns its "installLocation" value (empty string if not
        configured). Only used when the user opted into a custom directory by
        adding an "installLocation" field to config/applications.json.

    .PARAMETER WingetId
        The winget package id, e.g. "EclipseAdoptium.Temurin.17.JDK".
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$WingetId
    )

    if ($null -eq $sync -or $null -eq $sync.configs -or $null -eq $sync.configs.applicationsHashtable) {
        return ""
    }

    foreach ($entry in $sync.configs.applicationsHashtable.Values) {
        if ($entry.winget -and $entry.winget -ieq $WingetId) {
            $location = $entry.installLocation
            if ($location -is [string] -and -not [string]::IsNullOrWhiteSpace($location)) {
                return $location.Trim()
            }
            return ""
        }
    }

    return ""
}
