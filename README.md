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

## 📮 M365 Shared Mailbox Sent Items Configuration
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

## 📮 M365 Shared Mailbox Deleted Items Configuration
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
