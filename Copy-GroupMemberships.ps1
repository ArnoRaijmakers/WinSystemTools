<#
    .SYNOPSIS
    Copy-GroupMemberships.ps1

    .DESCRIPTION
    Copy all group memberships of a specified user to another user in Microsoft Entra ID.

    .LINK
    www.alitajran.com/copy-group-membership-from-one-user-to-another-in-microsoft-entra-id/

    .NOTES
    Written by: ALI TAJRAN
    Website:    www.alitajran.com
    LinkedIn:   linkedin.com/in/alitajran
    X:          x.com/alitajran

    .CHANGELOG
    V1.00, 05/25/2025 - Initial version
#>

# Define parameters for the script
param (
    [Parameter(Mandatory = $true, HelpMessage = "Enter the User ID (e.g., email or object ID) of the source Entra ID user")]
    [string]$UserId,
    [Parameter(HelpMessage = "Specify the path for the CSV output file")]
    [string]$CsvFilePath,
    [Parameter(HelpMessage = "Enable to display results in Out-GridView")]
    [switch]$OutGridView,
    [Parameter(HelpMessage = "Enter the User ID (e.g., email or object ID) of the target user to copy memberships to")]
    [string]$TargetUserId
)

# Connect to Microsoft Graph with required scopes
Connect-MgGraph -Scopes "User.Read.All", "Group.Read.All", "GroupMember.ReadWrite.All" -NoWelcome

# Initialize a list to store report data
$Report = [System.Collections.Generic.List[Object]]::new()

try {
    # If TargetUserId is provided, verify target user exists
    if ($TargetUserId) {
        $TargetUser = Get-MgUser -UserId $TargetUserId -ErrorAction Stop
    }

    # Fetch the source user's group memberships
    $EntraGroupMembers = Get-MgUserMemberOf -UserId $UserId -All -ErrorAction Stop

    # Check if the source user is a member of any groups
    if (-not $EntraGroupMembers) {
        Write-Host "No group memberships found for user: $UserId" -ForegroundColor Cyan
        return
    }

    # Process each group membership
    foreach ($EntraGroup in $EntraGroupMembers) {
        # Extract group details from AdditionalProperties
        $AdditionalProperties = $EntraGroup.AdditionalProperties

        # Determine group type
        $GroupType = if ($AdditionalProperties.groupTypes -contains "Unified" -and $AdditionalProperties.securityEnabled) {
            "Microsoft 365 (security-enabled)"
        }
        elseif ($AdditionalProperties.groupTypes -contains "Unified" -and -not $AdditionalProperties.securityEnabled) {
            "Microsoft 365"
        }
        elseif (-not ($AdditionalProperties.groupTypes -contains "Unified") -and $AdditionalProperties.securityEnabled -and $AdditionalProperties.mailEnabled) {
            "Mail-enabled security"
        }
        elseif (-not ($AdditionalProperties.groupTypes -contains "Unified") -and $AdditionalProperties.securityEnabled) {
            "Security"
        }
        elseif (-not ($AdditionalProperties.groupTypes -contains "Unified") -and $AdditionalProperties.mailEnabled) {
            "Distribution"
        }
        else {
            "N/A"
        }

        # Create a custom object for the group details
        $GroupDetails = [PSCustomObject]@{
            Id              = $EntraGroup.Id
            DisplayName     = if ($AdditionalProperties.displayName) { $AdditionalProperties.displayName } else { "N/A" }
            Email           = if ($AdditionalProperties.mail) { $AdditionalProperties.mail } else { "N/A" }
            SecurityEnabled = if ($AdditionalProperties.securityEnabled) { $AdditionalProperties.securityEnabled } else { "N/A" }
            MailEnabled     = if ($AdditionalProperties.mailEnabled) { $AdditionalProperties.mailEnabled } else { "N/A" }
            GroupType       = $GroupType
            Source          = if ($AdditionalProperties.onPremisesSyncEnabled) { "On-Premises" } else { "Cloud" }
        }
        # Add the group details to the report list
        $Report.Add($GroupDetails)
    }

    # Output to console only if TargetUserId is not provided
    if (-not $TargetUserId) {
        $Report | Sort-Object DisplayName | Format-Table -AutoSize
    }

    # Output to Out-GridView if specified
    if ($OutGridView) {
        $Report | Sort-Object DisplayName | Out-GridView -Title "Group Memberships for $UserId"
    }

    # Export to CSV if CsvFilePath is provided
    if ($CsvFilePath) {
        $Report | Sort-Object DisplayName | Export-Csv -Path $CsvFilePath -NoTypeInformation -Force
        Write-Host "Group memberships exported to $CsvFilePath" -ForegroundColor Cyan
    }

    # Copy memberships to target user if TargetUserId is provided
    if ($TargetUserId) {
        foreach ($Group in $Report) {
            try {
                # Check if the target user is already a member
                $ExistingMember = Get-MgGroupMember -GroupId $Group.Id -All | Where-Object { $_.Id -eq $TargetUser.Id }
                if (-not $ExistingMember) {
                    New-MgGroupMember -GroupId $Group.Id -DirectoryObjectId $TargetUser.Id -ErrorAction Stop
                    Write-Host "Added $TargetUserId to group: $($Group.DisplayName)" -ForegroundColor Green
                }
                else {
                    Write-Host "User $TargetUserId is already a member of group: $($Group.DisplayName)" -ForegroundColor Yellow
                }
            }
            catch {
                Write-Host "Failed to add $TargetUserId to group $($Group.DisplayName): $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }
}
catch {
    # Handle errors (e.g., invalid UserId, insufficient permissions, or Graph API issues)
    Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
}