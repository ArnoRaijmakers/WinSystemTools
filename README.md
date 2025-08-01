<div align="center">
 
# ☁️ Microsoft 365 Management ☁️

<br/>
</div>

### Retrieve Mailbox Delegations:
Note that Global Administrator or Exchange Administrator rights are required, and you will need to authenticate during the process
Save the attached "Retrieve-AllMailboxDelegations.ps1" file to your local `C:\Temp\`.

### Retrieve Mailbox Delegations:
Download the PowerShell script to your local machine:

<a href="./Retrieve-AllMailboxDelegations.ps1" download="Retrieve-AllMailboxDelegations.ps1">
  <button style="background-color: #0078d4; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 14px;">
    📥 Download Retrieve-AllMailboxDelegations.ps1
  </button>
</a>

Open PowerShell as administrator and execute the following commands in sequence.
```bash
Connect-ExchangeOnline -UserPrincipalName <e-mail>
```

Navigate to the script directory.
```bash
cd C:\Temp\
```

Execute the delegation retrieval script.
```bash
.\Retrieve-AllMailboxDelegations.ps1
```

Wait for the export to complete. The results will be showed and also saved to `C:\Temp\MailboxPermissions.csv`.

<br>
<br>

## 📮 M365 Shared Mailbox Sent Items Configuration
These commands are ideal for quickly configuring shared mailbox sent items behavior in Microsoft 365. By default, emails sent from a shared mailbox are stored in your personal Sent Items folder instead of the shared mailbox's Sent Items folder. Below are solutions to configure this behavior properly.

<br>

### PowerShell Configuration:
Note that Global Administrator or Exchange Administrator rights are required, and you will need to authenticate during the process.
Open PowerShell locally as administrator and paste the command below.
```bash
Connect-ExchangeOnline -UserPrincipalName <e-mail>
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
