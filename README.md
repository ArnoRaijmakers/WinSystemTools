<div align="center">
 
# ☁️ Microsoft 365 Management ☁️

<br/>
</div>

## Retrieve Mailbox Delegations:
Note that Global Administrator or Exchange Administrator rights are required, and you will need to authenticate during the process. This retrieves all the mailbox delegation of the whole M365 Tenant.

Download the PowerShell script to your local machine.
1. Right-click this link: [Retrieve-AllMailboxDelegations.ps1](https://raw.githubusercontent.com/ArnoRaijmakers/WinSystemTools/M365Management/Retrieve-AllMailboxDelegations.ps1)
2. Select "Save link as..."
3. Save to `C:\Scripts\`

<br>

Open local PowerShell as administrator and execute the following commands in sequence. First execute this command to login to Online Exchange.
```powershell
Connect-ExchangeOnline -UserPrincipalName j.doe@domain.com
```

Execute the delegation retrieval script.
```powershell
C:\Scripts\.\Retrieve-AllMailboxDelegations.ps1
```

Wait for the export to complete. The results will be showed and also saved to `C:\Temp\MailboxPermissions.csv`.

<br>
<br>

## Copy Group Memberschip:
Note that Global Administrator rights are required, and you will need to authenticate during the process. This script will copy all the group memberships from a existing user.

Download the PowerShell script to your local machine.
1. Right-click this link: [Copy-GroupMemberships.ps1](https://raw.githubusercontent.com/ArnoRaijmakers/WinSystemTools/M365Management/Copy-GroupMemberships.ps1)
2. Select "Save link as..."
3. Save to `C:\Scripts\`

<br>

Open local PowerShell as administrator and execute the following commands in sequence. First make sure you have installed Microsoft Graph.
```powershell
Install-Module Microsoft.Graph -Force
```

Execute this command to login to Entra ID.
```powershell
Connect-MgGraph -Scopes "User.Read.All", "Group.Read.All", "GroupMember.ReadWrite.All" -NoWelcome
```

Execute the script to copy the group memberships.
```powershell
C:\Scripts\.\Copy-GroupMemberships.ps1 -UserId "j.doe@domain.com" -TargetUserId "a.smith@domain.com"
```

<br>
<br>

## Grant Calender Access To Mailbox's
These commands are used to configure calendar access on mailboxes and must always be executed using PowerShell. Below are the possible permission roles and the specific rights they provide. Examples are shown afterwards.

- **Author:** CreateItems, DeleteOwnedItems, EditOwnedItems, FolderVisible, ReadItems
- **Contributor:** CreateItems, FolderVisible
- **Editor:** CreateItems, DeleteAllItems, DeleteOwnedItems, EditAllItems, EditOwnedItems, FolderVisible, ReadItems
- **NonEditingAuthor:** CreateItems, DeleteOwnedItems, FolderVisible, ReadItems
- **Owner:** CreateItems, CreateSubfolders, DeleteAllItems, DeleteOwnedItems, EditAllItems, EditOwnedItems, FolderContact, FolderOwner, FolderVisible, ReadItems
- **PublishingAuthor:** CreateItems, CreateSubfolders, DeleteOwnedItems, EditOwnedItems, FolderVisible, ReadItems
- **PublishingEditor:** CreateItems, CreateSubfolders, DeleteAllItems, DeleteOwnedItems, EditAllItems, EditOwnedItems, FolderVisible, ReadItems
- **Reviewer:** FolderVisible, ReadItems

<br>

### PowerShell Configuration:
Note you must have Global Administrator or Exchange Administrator rights. You will be prompted to authenticate during the process.
Open PowerShell as Administrator and run the following command:
```powershell
Connect-ExchangeOnline -UserPrincipalName j.doe@domain.com
```
> [!Important]
> Some Exchange naming may differ based on the language settings of the mailbox. For example the word `Calendar`, should be translated to Dutch, it is `Agenda`.

Retrieve mailbox granted permissions:
```powershell
Get-MailboxFolderPermission -Identity info@domain.com:\Calendar
```

If the user is not listed, use this command:
```powershell
Add-MailboxFolderPermission -Identity info@domain.com:\Calendar -User j.doe@domain.com -AccessRights Reviewer
```

If the user is already listed and the permissions need to be updated, use.
```powershell
Add-MailboxFolderPermission -Identity info@domain.com:\Calendar -User j.doe@domain.com -AccessRights Owner
```
> [!NOTE]
> To set global permissions for all users, use the argument `Default` for the `-User` parameter
> Afterwards, always check if the permissions are properly granted.

<br>
<br>

## M365 Shared Mailbox Sent Items Configuration
These commands are for configuring shared mailbox sent items behavior. Below are solutions to configure this behavior properly, so that sent items go into the shared mailbox’s Sent Items folder and not the personal mailbox.

<br>

### PowerShell Configuration:
Note that Global Administrator or Exchange Administrator rights are required, and you will need to authenticate during the process.
Open PowerShell locally as administrator and paste the command below.
```powershell
Connect-ExchangeOnline -UserPrincipalName j.doe@domain.com
```

Configure sent items to be stored only in the shared mailbox.
```powershell
powershellSet-MailboxSentItemsConfiguration -Identity info@domain.com -SendAsItemsCopiedTo From -SendOnBehalfOfItemsCopiedTo From
```
> [!NOTE]
> - When both values are set to `From`, emails sent from the shared mailbox are saved in the shared mailbox’s Sent Items folder.
> - When both values are set to `Sender`, emails sent from the shared mailbox are saved in the user’s personal Sent Items folder.

<br>

### Outlook Desktop Configuration:
Access account settings to configure sent items storage.
```
File > Account Settings > Account Settings > Select Account > Change > More Settings > Advanced
```

<br>

### 🖥️ Registry Fix (Client-Side):
Access Windows Registry Editor to modify Outlook behavior. To open this open the Run dialog via `Windows + R`, and type `regedit`.
Then nevigate to.
```regestry
Computer\HKEY_CURRENT_USER\Software\Microsoft\Office\<version>\Outlook\Preferences
```

> [!IMPORTANT]
> Replace `version` with your Office version number:
> - 16.0 for Office 2016, 2019, and Microsoft 365
> - 15.0 for Office 2013
> - 14.0 for Office 2010

Add the following DWORD (32-bit) value for delegate sent items behavior.
```regestry
Name: DelegateSentItemsStyle
Type: REG_DWORD  
Value: 1
```

> [!NOTE]
> - When the value is set to `1`, emails sent from the shared mailbox are saved in the shared mailbox’s Sent Items folder.
> - When the value is set to `0` or the DWORD is deleted, emails sent from the shared mailbox are saved in the user’s personal Sent Items folder.

<br>
<br>

## M365 Shared Mailbox Deleted Items Configuration
These commands are for configuring shared mailbox deleted items behavior. Below are solutions to configure this behavior properly, so that deleted items go into the shared mailbox’s Deleted Items folder and not the personal mailbox.

<br>

### PowerShell Configuration:
Note that Global Administrator or Exchange Administrator rights are required, and you will need to authenticate during the process.
Open PowerShell locally as administrator and paste the command below.
```powershell
Connect-ExchangeOnline -UserPrincipalName j.doe@domain.com
```

Configure sent items to be stored only in the shared mailbox.
```powershell
Set-Mailbox -Identity info@domain.com -MessageCopyForSentAsEnabled $true -MessageCopyForSendOnBehalfEnabled $true
Set-Mailbox -Identity info@domain.com -RetainDeletedItemsFor 30
```
> [!NOTE]
> - When both values are set to `$true`, items deleted from the shared mailbox are moved to the shared mailbox’s Deleted Items folder.
> - When both values are set to `$false`, items deleted from the shared mailbox are moved to the user’s personal Deleted Items folder.

<br>

### 🖥️ Registry Fix (Client-Side):
Access Windows Registry Editor to modify Outlook behavior. To open this open the Run dialog via `Windows + R`, and type `regedit`.
Then nevigate to.

```regestry
HKEY_CURRENT_USER\Software\Microsoft\Office\<version>\Outlook\Options\General
```

> [!IMPORTANT]
> Replace `version` with your Office version number:
> - 16.0 for Office 2016, 2019, and Microsoft 365
> - 15.0 for Office 2013
> - 14.0 for Office 2010

Add the following DWORD (32-bit) value for delegate sent items behavior.
```regestry
Name: DelegateWastebasketStyle
Type: REG_DWORD
Value: 4
```

> [!NOTE]
> - When the value is set to `4`, items deleted from the shared mailbox go to the shared mailbox’s Deleted Items folder.
> - When the value is set to `8`, items deleted from the shared mailbox go to the user’s personal Deleted Items folder.

<br>
<br>

## Errors With Microsoft 365 Apps
These commands are for configuring shared mailbox deleted items behavior. Below are solutions to configure this behavior properly, so that deleted items go into the shared mailbox’s Deleted Items folder and not the personal mailbox.

<br>

### Not Possible to Sign In To Microsoft 365 Apps:
Can cause problems with Azure Active Directory (AAD) authentication, Microsoft account sign-in, and Windows Hello/biometric login, especially in environments using Microsoft 365, OneDrive, Teams, or hybrid Azure AD join.<br>
In the path specified below, there should be a file listed called `Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy` or similar. This file can be deleted, after which the Office applications should be reopened and login should be attempted again.
```explorer
C:\Users\%USERNAME%\AppData\Local\Packages
```

### Issues with Outlook Profiles:
This folder stores local cache files and profiles used by Microsoft Outlook. Issues with these files can cause problems with Outlook performance, profile corruption, or connectivity issues with Microsoft 365 accounts, Exchange servers, or shared mailboxes.
If Outlook behaves unexpectedly, such as failing to open, deleting specific files from this folder can help resolve the issue. Common files stored here include OST-files (Offline Outlook Data Files) know as the profile.
```explorer
C:\Users\%USERNAME%\AppData\Local\Microsoft\Outlook
```
