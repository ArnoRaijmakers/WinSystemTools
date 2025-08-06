<div align="center">

# ⚙️ Windows Server/Computer Management ⚙️

<br/>
</div>

## 🛠️ Windows Server Scripts
Automate the deployment and configuration of Windows Server environments, including standalone servers, domain controllers, and additional domain controllers. The base configuration script applies essential settings and updates to the server. The domain controller setup script handles domain creation and DNS configuration, while the additional domain controller script manages domain joining and DNS synchronization. Each script includes the baseline server configuration by default, ensuring a consistent setup across all server roles.

<br>
### Comming soon

## 🏢 Active Directory Management
Here are some utility commands to validate and simplify the management of Active Directory users and computers. It is recommended to run these commands as an Administrator in PowerShell.

<br>

### DSregcmd:
This is Windows command is used to display the device registration status and information about how the device is joined to Azure Active Directory (Azure AD) or Active Directory Domain Services (AD DS).
```cmd
dsregcmd /status
```

<br>

### NetUser:
This is a command in Windows used for managing user accounts, allowing administrators to create, modify, display, or delete user accounts on local or domain systems.
```cmd
net user j.doe
```

<br>

### GPresult:
This is a Windows command that displays the Resultant Set of Policy (RSoP) information for a user and computer, showing which Group Policy settings are currently applied and their sources.
```cmd
gpresult /r
```

<br>

### Copy User Groups:
This script copies the exact group memberships of an already existing user and adds a new user to the same groups.
```powershell
$ReferenceUser = "j.doe"
$TargetUser  = "a.smith"

# Get groups of the existing user
$Groups = Get-ADUser -Identity $ReferenceUser  -Properties MemberOf | Select-Object -ExpandProperty MemberOf

# Add the new user to the same groups
foreach ($Group in $Groups) {
    Add-ADGroupMember -Identity $Group -Members $TargetUser 
}
```

<br>
<br>

<div align="center">

# 🖥️ Windows System Control Panel Shortcuts 🖥️

<br/>
</div>

## 🔧 Windows System Control Panel Access
These tools are ideal for quickly accessing various system settings and configurations. Below are commands that provide easy access to essential Windows Control Panel tools. These commands should be executed in the Run dialog. To open the Run dialog, simply press the following shortcut `Windows + R`, and then paste the command in the dialog.

<br>

### Control Panel:
Access the classic Control Panel on Windows quickly by using:
```run
control
```

<br>

### Network Panel:
```run
ncpa.cpl
```
or
```run
control netconnections
```

<br>

### System Panel:
```run
sysdm.cpl
```
or
```run
control system
```

<br>

### Devices and Printers:
```run
shell:::{A8A91A66-3A7D-4424-8D24-04E180695C7A}
```
or
```run
explorer shell:::{A8A91A66-3A7D-4424-8D24-04E180695C7A}
```
or
```run
control printers
```
