<div align="center">
 
# ☁️ M365 Shared Mailbox Sent Items Configuration ☁️

<br/>
</div>

## 📮 M365 Shared Mailbox Configuration
These commands are ideal for quickly configuring shared mailbox sent items behavior in Microsoft 365. By default, emails sent from a shared mailbox are stored in your personal Sent Items folder instead of the shared mailbox's Sent Items folder. Below are solutions to configure this behavior properly.

<br>

### PowerShell Configuration:
Configure sent items to be stored only in the shared mailbox but Global administrator or Exchange adminisrator rights are needed.
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
Computer\HKEY_CURRENT_USER\Software\Microsoft\Office\<versie>\Outlook\Preferences
```

<br>

Add the following DWORD value for delegate sent items behavior.
```bash
Name: DelegateSentItemsStyle
Type: REG_DWORD  
Value: 1
```
