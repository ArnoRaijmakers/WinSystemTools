<div align="center">

# ⚙️ Windows Server Management ⚙️

<br/>
</div>

## 🛠️ Windows Server Scripts
Automate the deployment and configuration of Windows Server environments, including standalone servers, domain controllers, and additional domain controllers. The base configuration script applies essential settings and updates to the server. The domain controller setup script handles domain creation and DNS configuration, while the additional domain controller script manages domain joining and DNS synchronization. Each script includes the baseline server configuration by default, ensuring a consistent setup across all server roles.

<br>

## 🏢 Active Directory Management
Here are some utility commands to validate and simplify the management of Active Directory users and computers. It is recommended to run these commands as an Administrator in PowerShell.

<br>

### NetUser:
This is a command in Windows used for managing user accounts, allowing administrators to create, modify, display, or delete user accounts on local or domain systems.
```bash
net user j.doe
```

<br>

### dsregcmd /status:
This is Windows command is used to display the device registration status and information about how the device is joined to Azure Active Directory (Azure AD) or Active Directory Domain Services (AD DS).
```bash
dsregcmd /status
```

<br>

### gpresult /r:
This is a Windows command that displays the Resultant Set of Policy (RSoP) information for a user and computer, showing which Group Policy settings are currently applied and their sources.
```bash
gpresult /r
```

<br>

### Copy User Groups:
This script copies the exact group memberships of an already existing user and adds a new user to the same groups.
```bash
$ReferenceUser = "j.doe"
$TargetUser  = "a.smith"

# Get groups of the existing user
$Groups = Get-ADUser -Identity $ReferenceUser  -Properties MemberOf | Select-Object -ExpandProperty MemberOf

# Add the new user to the same groups
foreach ($Group in $Groups) {
    Add-ADGroupMember -Identity $Group -Members $TargetUser 
}
```
