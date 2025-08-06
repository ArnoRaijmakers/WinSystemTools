<div align="center">
 
# ☁️ Microsoft 365 Management ☁️

<br/>
</div>

### Retrieve Mailbox Delegations:
Note that Global Administrator or Exchange Administrator rights are required, and you will need to authenticate during the process. This retrieves all the mailbox delegation of the whole M365 Tenant.

Download the PowerShell script to your local machine.
1. Right-click this link: [Retrieve-AllMailboxDelegations.ps1](https://raw.githubusercontent.com/ArnoRaijmakers/WinSystemTools/M365Management/Retrieve-AllMailboxDelegations.ps1)
2. Select "Save link as..."
3. Save to `C:\Scripts\`

<br>

Open PowerShell as administrator and execute the following commands in sequence.
```bash
Connect-ExchangeOnline -UserPrincipalName j.doe@domain.com
```

Execute the delegation retrieval script.
```bash
C:\Scripts\.\Retrieve-AllMailboxDelegations.ps1
```

Wait for the export to complete. The results will be showed and also saved to `C:\Temp\MailboxPermissions.csv`.

<br>
<br>

### Copy Group Memberschip:
Note that Global Administrator rights are required, and you will need to authenticate during the process. This will copy only the group memberships and not the distribution lists.

Download the PowerShell script to your local machine.
1. Right-click this link: [Copy-GroupMemberships.ps1](https://raw.githubusercontent.com/ArnoRaijmakers/WinSystemTools/M365Management/Copy-GroupMemberships.ps1)
2. Select "Save link as..."
3. Save to `C:\Scripts\`

<br>

Open PowerShell as administrator and execute the following commands in sequence.
```bash
Connect-MgGraph -Scopes "User.Read.All", "Group.Read.All", "GroupMember.ReadWrite.All" -NoWelcome
```

Execute the script to copy the group memberships.
```bash
C:\Scripts\.\Copy-GroupMemberships.ps1 -UserId "j.doe@domain.com" -TargetUserId "a.smith@domain.com"
```

<br>
<br>

## 📮 M365 Shared Mailbox Sent Items Configuration
These commands are ideal for quickly configuring shared mailbox sent items behavior in Microsoft 365. By default, emails sent from a shared mailbox are stored in your personal Sent Items folder instead of the shared mailbox's Sent Items folder. Below are solutions to configure this behavior properly.

<br>

### PowerShell Configuration:
Note that Global Administrator or Exchange Administrator rights are required, and you will need to authenticate during the process.
Open PowerShell locally as administrator and paste the command below.
```bash
Connect-ExchangeOnline -UserPrincipalName j.doe@domain.com
```

Configure sent items to be stored only in the shared mailbox.
```bash
powershellSet-MailboxSentItemsConfiguration -Identity sharedmailbox@yourdomain.com -SendAsItemsCopiedTo From -SendOnBehalfOfItemsCopiedTo From
```

<br>

### Outlook Desktop Configuration:
Access account settings to configure sent items storage.
```bash
File > Account Settings > Account Settings > Select Account > Change > More Settings > Advanced
```

<br>

### Registry Configuration (Local Outlook Only):
Access Windows Registry Editor to modify Outlook behavior. To open this open the Run dialog via `Windows + R`, and type `regedit`.
Then nevigate to.
```bash
Computer\HKEY_CURRENT_USER\Software\Microsoft\Office\<version>\Outlook\Preferences
```

Add the following DWORD value for delegate sent items behavior.
```bash
Name: DelegateSentItemsStyle
Type: REG_DWORD  
Value: 1
```
