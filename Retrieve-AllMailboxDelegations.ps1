$CsvPath = "C:\Temp\MailboxPermissions.csv"

Write-Host "Fetching mailboxes" -ForegroundColor Cyan

$Mbx = Get-ExoMailbox -RecipientTypeDetails UserMailbox, SharedMailbox -ResultSize Unlimited -PropertySet Delivery -Properties RecipientTypeDetails, DisplayName | Select-Object DisplayName, UserPrincipalName, RecipientTypeDetails, GrantSendOnBehalfTo

If ($Mbx.Count -eq 0) {
    Write-Error "No mailboxes found. Script exiting..." -ErrorAction Stop
} 

$Report = [System.Collections.Generic.List[Object]]::new()

$ProgressDelta = 100 / ($Mbx.count); $PercentComplete = 0; $MbxNumber = 0

ForEach ($M in $Mbx) {

    $MbxNumber++

    $MbxStatus = $M.DisplayName + " [" + $MbxNumber + "/" + $Mbx.Count + "]"

    Write-Progress -Activity "Checking permissions for mailbox" -Status $MbxStatus -PercentComplete $PercentComplete

    $PercentComplete += $ProgressDelta

    $Permissions = Get-ExoRecipientPermission -Identity $M.UserPrincipalName | Where-Object { $_.Trustee -ne "NT AUTHORITY\SELF" }
    If ($Null -ne $Permissions) { 

        # Grab information about SendAs permission and output it into the report
        ForEach ($Permission in $Permissions) {
            $ReportLine = [PSCustomObject] @{
                Mailbox     = $M.DisplayName
                UPN         = $M.UserPrincipalName
                Permission  = $Permission | Select-Object -ExpandProperty AccessRights
                AssignedTo  = $Permission.Trustee
                MailboxType = $M.RecipientTypeDetails
            }
            $Report.Add($ReportLine)
        }
    }

    # Grab information about FullAccess permissions 
    $Permissions = Get-ExoMailboxPermission -Identity $M.UserPrincipalName | Where-Object { $_.User -Like "*@*" }

    If ($Null -ne $Permissions) {
        # Grab each permission and output it into the report
        ForEach ($Permission in $Permissions) {
            $ReportLine = [PSCustomObject] @{
                Mailbox     = $M.DisplayName
                UPN         = $M.UserPrincipalName
                Permission  = $Permission | Select-Object -ExpandProperty AccessRights
                AssignedTo  = $Permission.User
                MailboxType = $M.RecipientTypeDetails
            }
            $Report.Add($ReportLine)
        }
    }

    # Check if this mailbox has granted Send on Behalf of permission to anyone
    If (![string]::IsNullOrEmpty($M.GrantSendOnBehalfTo)) {

        ForEach ($Permission in $M.GrantSendOnBehalfTo) {
            $ReportLine = [PSCustomObject] @{
                Mailbox     = $M.DisplayName
                UPN         = $M.UserPrincipalName
                Permission  = "Send on Behalf Of"
                AssignedTo  = (Get-ExoRecipient -Identity $Permission).PrimarySmtpAddress
                MailboxType = $M.RecipientTypeDetail
            }
            $Report.Add($ReportLine)
        }
    }
}

# Complete the progress bar

Write-Progress -Activity "Checking permissions for mailbox" -Completed

$Report | Sort-Object -Property @{Expression = { $_.MailboxType }; Ascending = $False }, Mailbox | Out-GridView -Title "Microsoft 365 Mailbox Permissions"

$Report | Sort-Object -Property @{Expression = { $_.MailboxType }; Ascending = $False }, Mailbox | Export-CSV $CsvPath -NoTypeInformation -Encoding utf8

Write-Host "All done." $Mbx.Count "mailboxes scanned. Find the CSV file in $CsvPath " -ForegroundColor Cyan