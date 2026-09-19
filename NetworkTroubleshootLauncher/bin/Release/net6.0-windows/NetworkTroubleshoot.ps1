# Load Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create main form - modern glass-inspired style
$form = New-Object System.Windows.Forms.Form
$form.Text = "IT Infrastructure Toolkit"
$form.Size = New-Object System.Drawing.Size(600, 820)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = "#eef4ff"
$form.Padding = New-Object System.Windows.Forms.Padding(0, 0, 0, 0)

function Set-ModernButtonStyle {
    param(
        [System.Windows.Forms.Button]$Button,
        [string]$BackColor = "#4f46e5",
        [string]$ForeColor = "White",
        [bool]$Large = $false
    )

    $Button.BackColor = $BackColor
    $Button.ForeColor = $ForeColor
    $Button.FlatStyle = "Flat"
    $Button.FlatAppearance.BorderSize = 0
    $Button.FlatAppearance.MouseOverBackColor = "#4338ca"
    $Button.FlatAppearance.MouseDownBackColor = "#312e81"
    $Button.Cursor = "Hand"
    $Button.Font = if ($Large) { New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold) } else { New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold) }
}

# Create Header Panel
$headerPanel = New-Object System.Windows.Forms.Panel
$headerPanel.Size = New-Object System.Drawing.Size(600, 95)
$headerPanel.Location = New-Object System.Drawing.Point(0, 0)
$headerPanel.BackColor = "#1d4ed8"
$form.Controls.Add($headerPanel)

# Add Main Title
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "IT Infrastructure Toolkit"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = "White"
$titleLabel.Location = New-Object System.Drawing.Point(45, 20)
$titleLabel.AutoSize = $true
$headerPanel.Controls.Add($titleLabel)

# Add Subtitle
$subtitleLabel = New-Object System.Windows.Forms.Label
$subtitleLabel.Text = "Professional tools for network troubleshooting & system optimization"
$subtitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$subtitleLabel.ForeColor = "#c7d2fe"
$subtitleLabel.Location = New-Object System.Drawing.Point(45, 55)
$subtitleLabel.Size = New-Object System.Drawing.Size(520, 30)
$headerPanel.Controls.Add($subtitleLabel)

# Create Output Box - NOW POSITIONED BELOW BUTTON 13
$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Multiline = $true
$outputBox.ScrollBars = "Vertical"
$outputBox.Location = New-Object System.Drawing.Point(45, 560)
$outputBox.Size = New-Object System.Drawing.Size(510, 200)
$outputBox.Font = New-Object System.Drawing.Font("Consolas", 10)
$outputBox.ReadOnly = $true
$outputBox.BackColor = "#ffffff"
$outputBox.BorderStyle = "FixedSingle"
$form.Controls.Add($outputBox)

# Function to append output
function Append-Output {
    param([string]$text)
    $outputBox.AppendText($text + "`r`n")
    $outputBox.ScrollToCaret()
}

function Get-ADCommandCatalog {
    param(
        [string]$DomainName = "domain.local"
    )

    $normalizedDomain = $DomainName.Trim()
    if ([string]::IsNullOrWhiteSpace($normalizedDomain)) {
        $normalizedDomain = "domain.local"
    }

    $safeDomain = $normalizedDomain.Replace(" ", "")
    $ldapParts = $safeDomain.Split('.') | Where-Object { $_ -and $_.Trim() }
    $ldapBase = if ($ldapParts.Count -gt 0) { ($ldapParts | ForEach-Object { "DC=$_" }) -join "," } else { "DC=domain,DC=local" }
    $ldapUsers = "OU=Users,$ldapBase"
    $ldapComputers = "OU=Computers,$ldapBase"
    $ldapGroups = "OU=Groups,$ldapBase"

    return @{
        "DOMAIN CONTROLLER & DOMAIN INFO" = @(
            @{ Command = "nltest /dclist:$safeDomain"; Description = "Lists the domain controllers for the target domain." },
            @{ Command = "nltest /domain_trusts"; Description = "Shows domain trusts and trust relationships for the current forest." },
            @{ Command = "nltest /sc_query:$safeDomain"; Description = "Checks secure channel connectivity to the target domain." },
            @{ Command = "netdom query fsmo"; Description = "Displays the Flexible Single Master Operations roles in the domain." },
            @{ Command = "dcdiag /v"; Description = "Runs a full domain controller diagnostic report to detect AD issues." },
            @{ Command = "repadmin /replsummary"; Description = "Summarizes replication health across domain controllers." },
            @{ Command = "repadmin /showrepl"; Description = "Shows replication status and failures between domain controllers." },
            @{ Command = "repadmin /syncall"; Description = "Forces a replication sync across all domain controllers." },
            @{ Command = "net time /domain"; Description = "Displays the domain time source and time synchronization status." },
            @{ Command = "wmic /namespace:\root\directory\ldap path ds_domain get dsname"; Description = "Shows the LDAP domain name and domain configuration metadata." },
            @{ Command = "nltest /dsgetdc:$safeDomain"; Description = "Finds the domain controller that serves the target domain." }
        );
        "USER MANAGEMENT" = @(
            @{ Command = "Get-ADUser -Filter *"; Description = "Lists all Active Directory user accounts in the directory." },
            @{ Command = "Get-ADUser -Identity 'jdoe'"; Description = "Shows the details of a specific user account." },
            @{ Command = "New-ADUser -Name 'John Doe' -SamAccountName 'jdoe' -UserPrincipalName 'jdoe@$safeDomain' -AccountPassword (ConvertTo-SecureString 'P@ssw0rd!' -AsPlainText -Force) -Enabled `$true"; Description = "Creates a new AD user with a password and enables the account." },
            @{ Command = "Set-ADUser -Identity 'jdoe' -DisplayName 'John Doe'"; Description = "Updates the display name for an existing AD user." },
            @{ Command = "Set-ADUser -Identity 'jdoe' -Enabled `$false"; Description = "Disables a user account without deleting it." },
            @{ Command = "Set-ADUser -Identity 'jdoe' -PasswordNeverExpires `$true"; Description = "Turns off the password expiration setting for a user." },
            @{ Command = "Disable-ADAccount -Identity 'jdoe'"; Description = "Disables the sign-in capability of a selected user account." },
            @{ Command = "Enable-ADAccount -Identity 'jdoe'"; Description = "Re-enables a previously disabled AD account." },
            @{ Command = "Reset-ADUserPassword -Identity 'jdoe' -NewPassword (ConvertTo-SecureString 'NewP@ssw0rd!' -AsPlainText -Force)"; Description = "Resets the password on an AD account quickly for password recovery tasks." },
            @{ Command = "Remove-ADUser -Identity 'jdoe'"; Description = "Deletes the selected user account from Active Directory." },
            @{ Command = "Get-ADUser -Filter * | Select-Object Name,SamAccountName,Enabled"; Description = "Displays an easy-to-read report of user names, IDs, and account status." }
        );
        "GROUP MANAGEMENT" = @(
            @{ Command = "Get-ADGroup -Filter *"; Description = "Lists all AD groups in the directory." },
            @{ Command = "Get-ADGroup -Identity 'IT Support'"; Description = "Shows the settings and members of a specific group." },
            @{ Command = "New-ADGroup -Name 'IT Support' -GroupScope Global -GroupCategory Security"; Description = "Creates a new security group for an AD team or department." },
            @{ Command = "Add-ADGroupMember -Identity 'IT Support' -Members 'jdoe'"; Description = "Adds a user to a target AD group." },
            @{ Command = "Remove-ADGroupMember -Identity 'IT Support' -Members 'jdoe'"; Description = "Removes a user from a selected AD group." },
            @{ Command = "Get-ADGroupMember -Identity 'IT Support'"; Description = "Shows the current members inside a group." }
        );
        "ORGANIZATIONAL UNIT MANAGEMENT" = @(
            @{ Command = "Get-ADOrganizationalUnit -Filter *"; Description = "Lists all OUs available in the directory." },
            @{ Command = "New-ADOrganizationalUnit -Name 'Users' -Path '$ldapBase'"; Description = "Creates a new organizational unit under the AD root." },
            @{ Command = "New-ADOrganizationalUnit -Name 'Computers' -Path '$ldapBase'"; Description = "Creates an OU for computer objects in the domain." },
            @{ Command = "New-ADOrganizationalUnit -Name 'Servers' -Path '$ldapBase'"; Description = "Creates a dedicated OU for servers or special systems." },
            @{ Command = "Move-ADObject -Identity 'CN=jdoe,OU=Users,$ldapBase' -TargetPath '$ldapUsers'"; Description = "Moves a user object into the selected users OU." },
            @{ Command = "Move-ADObject -Identity 'CN=Server01,OU=Computers,$ldapBase' -TargetPath '$ldapComputers'"; Description = "Moves a computer object into the computers OU." },
            @{ Command = "Get-ADObject -Filter * -SearchBase '$ldapBase' -Properties *"; Description = "Shows all objects under the domain base with their attributes." }
        );
        "COMPUTER MANAGEMENT" = @(
            @{ Command = "Get-ADComputer -Filter *"; Description = "Lists every computer object in Active Directory." },
            @{ Command = "Get-ADComputer -Identity 'PC01'"; Description = "Shows the details for a specific computer account." },
            @{ Command = "New-ADComputer -Name 'PC01' -Path '$ldapComputers'"; Description = "Creates a computer account in the computers OU." },
            @{ Command = "Remove-ADComputer -Identity 'PC01'"; Description = "Deletes a computer object from AD." },
            @{ Command = "Get-ADComputer -Filter * | Select-Object Name,OperatingSystem,LastLogonDate"; Description = "Displays a quick inventory of computers and their OS details." }
        );
        "DNS MANAGEMENT" = @(
            @{ Command = "Get-DnsServerZone"; Description = "Lists all DNS zones configured on the server." },
            @{ Command = "Get-DnsServerResourceRecord -ZoneName '$safeDomain'"; Description = "Shows DNS records for the target domain zone." },
            @{ Command = "Add-DnsServerResourceRecordA -Name 'server' -ZoneName '$safeDomain' -IPv4Address '192.168.10.10'"; Description = "Creates a new A record for a host in the AD domain." },
            @{ Command = "Remove-DnsServerResourceRecord -ZoneName '$safeDomain' -Name 'server' -RRType 'A'"; Description = "Deletes a host A record from the DNS zone." },
            @{ Command = "Clear-DnsServerCache"; Description = "Flushes the local DNS cache to force new lookups." },
            @{ Command = "Resolve-DnsName $safeDomain"; Description = "Resolves the domain name to its current IP address." }
        );
        "SEARCHING & REPORTING" = @(
            @{ Command = "Get-ADUser -Filter * | Select-Object Name,SamAccountName,Enabled"; Description = "Generates a simplified user report with key account details." },
            @{ Command = "Get-ADComputer -Filter * | Select-Object Name,OperatingSystem"; Description = "Creates a readable computer inventory report." },
            @{ Command = "Get-ADGroup -Filter * | Select-Object Name,GroupCategory,GroupScope"; Description = "Shows group names and the scope/category of each group." },
            @{ Command = "Get-ADObject -SearchBase '$ldapBase' -Filter * -Properties *"; Description = "Lists all objects under the domain base and their attributes." },
            @{ Command = "Get-ADUser -Filter * -SearchBase '$ldapUsers'"; Description = "Shows all user accounts inside the target OU structure." },
            @{ Command = "Get-ADGroup -Filter * -SearchBase '$ldapGroups'"; Description = "Shows all groups present in the group OU." },
            @{ Command = "Search-ADAccount -UsersOnly"; Description = "Checks users for lockouts, disabled accounts, or password issues." }
        );
        "AD SITE & SERVICES" = @(
            @{ Command = "Get-ADReplicationSite"; Description = "Lists AD replication sites configured in the forest." },
            @{ Command = "Get-ADReplicationSubnet"; Description = "Shows subnet objects used by AD sites." },
            @{ Command = "Get-ADReplicationSiteLink"; Description = "Displays AD site links and replication connections." },
            @{ Command = "Get-ADDomainController -Filter *"; Description = "Lists every domain controller in the domain." },
            @{ Command = "Get-ADSite"; Description = "Displays the AD sites in the current forest." }
        );
        "AUTOMATION & TROUBLESHOOTING" = @(
            @{ Command = "ping $safeDomain"; Description = "Pings the target domain to verify network connectivity." },
            @{ Command = "nslookup $safeDomain"; Description = "Resolves the domain name with DNS to confirm name resolution." },
            @{ Command = "Test-NetConnection $safeDomain -Port 389"; Description = "Checks whether LDAP traffic to the domain works over the network." },
            @{ Command = "Test-Connection $safeDomain"; Description = "Verifies connectivity to the domain or a remote system." },
            @{ Command = "repadmin /replsummary"; Description = "Confirms if replication is healthy and identifies failure points." },
            @{ Command = "repadmin /showrepl"; Description = "Shows detailed domain controller replication status and failures." },
            @{ Command = "dcdiag /v /c"; Description = "Runs a conservative full AD health and connectivity test." },
            @{ Command = "Get-WinEvent -LogName 'Directory Service' -MaxEvents 20"; Description = "Shows recent Active Directory service events and errors." },
            @{ Command = "Get-Service -Name 'NETLOGON','KDC'"; Description = "Checks whether critical AD services are running and healthy." }
        );
        "COMMON TARGETS & PATHS" = @(
            @{ Command = "Domain: $safeDomain"; Description = "This is the current target domain used in the cheatsheet examples." },
            @{ Command = "LDAP Base: $ldapBase"; Description = "This shows the base DN used when targeting AD objects and OUs." },
            @{ Command = "User OU: $ldapUsers"; Description = "This is the OU path used for user objects in the domain." },
            @{ Command = "Computer OU: $ldapComputers"; Description = "This is the OU path where computer objects are typically stored." },
            @{ Command = "Group OU: $ldapGroups"; Description = "This is the OU path used for group objects." },
            @{ Command = "Example User: jdoe@$safeDomain"; Description = "Sample user principal name used in the examples." },
            @{ Command = "Example Computer: PC01"; Description = "Example machine name used in the AD computer examples." },
            @{ Command = "Example Group: IT Support"; Description = "Sample AD security group used in the example commands." }
        )
    }
}

function Get-ADCheatSheetText {
    param(
        [string]$DomainName = "domain.local"
    )

    $normalizedDomain = $DomainName.Trim()
    if ([string]::IsNullOrWhiteSpace($normalizedDomain)) {
        $normalizedDomain = "domain.local"
    }

    $safeDomain = $normalizedDomain.Replace(" ", "")
    $ldapParts = $safeDomain.Split('.') | Where-Object { $_ -and $_.Trim() }
    $ldapBase = if ($ldapParts.Count -gt 0) { ($ldapParts | ForEach-Object { "DC=$_" }) -join "," } else { "DC=domain,DC=local" }
    $ldapUsers = "OU=Users,$ldapBase"
    $ldapComputers = "OU=Computers,$ldapBase"
    $ldapGroups = "OU=Groups,$ldapBase"

    $sections = @(
        "DOMAIN CONTROLLER & DOMAIN INFO",
        "USER MANAGEMENT",
        "GROUP MANAGEMENT",
        "ORGANIZATIONAL UNIT MANAGEMENT",
        "COMPUTER MANAGEMENT",
        "DNS MANAGEMENT",
        "SEARCHING & REPORTING",
        "AD SITE & SERVICES",
        "AUTOMATION & TROUBLESHOOTING",
        "COMMON TARGETS & PATHS"
    )

    $commands = @{
        "DOMAIN CONTROLLER & DOMAIN INFO" = @(
            "nltest /dclist:$safeDomain",
            "nltest /domain_trusts",
            "nltest /sc_query:$safeDomain",
            "netdom query fsmo",
            "dcdiag /v",
            "repadmin /replsummary",
            "repadmin /showrepl",
            "repadmin /syncall",
            "net time /domain",
            "wmic /namespace:\\root\\directory\\ldap path ds_domain get dsname",
            "nltest /dsgetdc:$safeDomain"
        );
        "USER MANAGEMENT" = @(
            "Get-ADUser -Filter *",
            "Get-ADUser -Identity 'jdoe'",
            "New-ADUser -Name 'John Doe' -SamAccountName 'jdoe' -UserPrincipalName 'jdoe@$safeDomain' -AccountPassword (ConvertTo-SecureString 'P@ssw0rd!' -AsPlainText -Force) -Enabled `$true",
            "Set-ADUser -Identity 'jdoe' -DisplayName 'John Doe'",
            "Set-ADUser -Identity 'jdoe' -Enabled `$false",
            "Set-ADUser -Identity 'jdoe' -PasswordNeverExpires `$true",
            "Disable-ADAccount -Identity 'jdoe'",
            "Enable-ADAccount -Identity 'jdoe'",
            "Reset-ADUserPassword -Identity 'jdoe' -NewPassword (ConvertTo-SecureString 'NewP@ssw0rd!' -AsPlainText -Force)",
            "Remove-ADUser -Identity 'jdoe'",
            "Get-ADUser -Filter * | Select-Object Name,SamAccountName,Enabled"
        );
        "GROUP MANAGEMENT" = @(
            "Get-ADGroup -Filter *",
            "Get-ADGroup -Identity 'IT Support'",
            "New-ADGroup -Name 'IT Support' -GroupScope Global -GroupCategory Security",
            "Add-ADGroupMember -Identity 'IT Support' -Members 'jdoe'",
            "Remove-ADGroupMember -Identity 'IT Support' -Members 'jdoe'",
            "Get-ADGroupMember -Identity 'IT Support'"
        );
        "ORGANIZATIONAL UNIT MANAGEMENT" = @(
            "Get-ADOrganizationalUnit -Filter *",
            "New-ADOrganizationalUnit -Name 'Users' -Path '$ldapBase'",
            "New-ADOrganizationalUnit -Name 'Computers' -Path '$ldapBase'",
            "New-ADOrganizationalUnit -Name 'Servers' -Path '$ldapBase'",
            "Move-ADObject -Identity 'CN=jdoe,OU=Users,$ldapBase' -TargetPath '$ldapUsers'",
            "Move-ADObject -Identity 'CN=Server01,OU=Computers,$ldapBase' -TargetPath '$ldapComputers'",
            "Get-ADObject -Filter * -SearchBase '$ldapBase' -Properties *"
        );
        "COMPUTER MANAGEMENT" = @(
            "Get-ADComputer -Filter *",
            "Get-ADComputer -Identity 'PC01'",
            "New-ADComputer -Name 'PC01' -Path '$ldapComputers'",
            "Remove-ADComputer -Identity 'PC01'",
            "Get-ADComputer -Filter * | Select-Object Name,OperatingSystem,LastLogonDate"
        );
        "DNS MANAGEMENT" = @(
            "Get-DnsServerZone",
            "Get-DnsServerResourceRecord -ZoneName '$safeDomain'",
            "Add-DnsServerResourceRecordA -Name 'server' -ZoneName '$safeDomain' -IPv4Address '192.168.10.10'",
            "Remove-DnsServerResourceRecord -ZoneName '$safeDomain' -Name 'server' -RRType 'A'",
            "Clear-DnsServerCache",
            "Resolve-DnsName $safeDomain"
        );
        "SEARCHING & REPORTING" = @(
            "Get-ADUser -Filter * | Select-Object Name,SamAccountName,Enabled",
            "Get-ADComputer -Filter * | Select-Object Name,OperatingSystem",
            "Get-ADGroup -Filter * | Select-Object Name,GroupCategory,GroupScope",
            "Get-ADObject -SearchBase '$ldapBase' -Filter * -Properties *",
            "Get-ADUser -Filter * -SearchBase '$ldapUsers'",
            "Get-ADGroup -Filter * -SearchBase '$ldapGroups'",
            "Search-ADAccount -UsersOnly"
        );
        "AD SITE & SERVICES" = @(
            "Get-ADReplicationSite",
            "Get-ADReplicationSubnet",
            "Get-ADReplicationSiteLink",
            "Get-ADDomainController -Filter *",
            "Get-ADSite"
        );
        "AUTOMATION & TROUBLESHOOTING" = @(
            "ping $safeDomain",
            "nslookup $safeDomain",
            "Test-NetConnection $safeDomain -Port 389",
            "Test-Connection $safeDomain",
            "repadmin /replsummary",
            "repadmin /showrepl",
            "dcdiag /v /c",
            "Get-WinEvent -LogName 'Directory Service' -MaxEvents 20",
            "Get-Service -Name 'NETLOGON','KDC'"
        );
        "COMMON TARGETS & PATHS" = @(
            "Domain: $safeDomain",
            "LDAP Base: $ldapBase",
            "User OU: $ldapUsers",
            "Computer OU: $ldapComputers",
            "Group OU: $ldapGroups",
            "Example User: jdoe@$safeDomain",
            "Example Computer: PC01",
            "Example Group: IT Support"
        )
    }

    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.AppendLine("Active Directory Command Cheatsheet")
    [void]$sb.AppendLine("Target Domain: $safeDomain")
    [void]$sb.AppendLine("LDAP Base: $ldapBase")
    [void]$sb.AppendLine("")

    foreach ($section in $sections) {
        [void]$sb.AppendLine("[$section]")
        foreach ($cmd in $commands[$section]) {
            [void]$sb.AppendLine($cmd)
        }
        [void]$sb.AppendLine("")
    }

    return $sb.ToString()
}

function Start-CommandInShell {
    param(
        [string]$CommandText,
        [ValidateSet('PowerShell', 'CMD')]
        [string]$Shell = 'PowerShell',
        [bool]$RunAsAdmin = $false
    )

    $trimmed = $CommandText.Trim()
    if ([string]::IsNullOrWhiteSpace($trimmed)) {
        [System.Windows.Forms.MessageBox]::Show("Please enter a command before running.", "Missing command", "OK", "Warning") | Out-Null
        return
    }

    try {
        if ($Shell -eq 'PowerShell') {
            $file = 'powershell.exe'
            $args = @('-NoExit', '-NoLogo', '-Command', $trimmed)
        }
        else {
            $file = 'cmd.exe'
            $args = @('/K', $trimmed)
        }

        if ($RunAsAdmin) {
            Start-Process $file -Verb RunAs -ArgumentList $args | Out-Null
        }
        else {
            Start-Process $file -ArgumentList $args | Out-Null
        }
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Error: $($_.Exception.Message)", "Execution failed", "OK", "Error") | Out-Null
    }
}

function Show-CommandEditorDialog {
    param(
        [string]$CommandText = ""
    )

    $dialog = New-Object System.Windows.Forms.Form
    $dialog.Text = "Edit Command Before Running"
    $dialog.Size = New-Object System.Drawing.Size(900, 320)
    $dialog.StartPosition = "CenterParent"
    $dialog.FormBorderStyle = "FixedDialog"
    $dialog.MaximizeBox = $false
    $dialog.MinimizeBox = $false
    $dialog.BackColor = "#f8fafc"

    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Text = "Edit the selected command before running it:"
    $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $titleLabel.Location = New-Object System.Drawing.Point(20, 18)
    $titleLabel.AutoSize = $true
    $dialog.Controls.Add($titleLabel)

    $shellLabel = New-Object System.Windows.Forms.Label
    $shellLabel.Text = "Run in:"
    $shellLabel.Location = New-Object System.Drawing.Point(20, 198)
    $shellLabel.Size = New-Object System.Drawing.Size(80, 20)
    $shellLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $dialog.Controls.Add($shellLabel)

    $shellCombo = New-Object System.Windows.Forms.ComboBox
    $shellCombo.Location = New-Object System.Drawing.Point(100, 194)
    $shellCombo.Size = New-Object System.Drawing.Size(140, 24)
    $shellCombo.DropDownStyle = "DropDownList"
    $shellCombo.Items.AddRange(@("PowerShell", "CMD"))
    $shellCombo.SelectedIndex = 0
    $dialog.Controls.Add($shellCombo)

    $adminCheck = New-Object System.Windows.Forms.CheckBox
    $adminCheck.Text = "Run as Administrator"
    $adminCheck.Location = New-Object System.Drawing.Point(270, 196)
    $adminCheck.Size = New-Object System.Drawing.Size(180, 24)
    $adminCheck.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $dialog.Controls.Add($adminCheck)

    $commandTextBox = New-Object System.Windows.Forms.TextBox
    $commandTextBox.Multiline = $true
    $commandTextBox.ScrollBars = "Vertical"
    $commandTextBox.Location = New-Object System.Drawing.Point(20, 52)
    $commandTextBox.Size = New-Object System.Drawing.Size(840, 120)
    $commandTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
    $commandTextBox.BackColor = "#ffffff"
    $commandTextBox.BorderStyle = "FixedSingle"
    $commandTextBox.Text = $CommandText.Trim()
    $dialog.Controls.Add($commandTextBox)

    $runBtn = New-Object System.Windows.Forms.Button
    $runBtn.Text = "Run"
    $runBtn.Location = New-Object System.Drawing.Point(560, 232)
    $runBtn.Size = New-Object System.Drawing.Size(160, 38)
    $runBtn.BackColor = "#2563eb"
    $runBtn.ForeColor = "White"
    $runBtn.FlatStyle = "Flat"
    $runBtn.Add_Click({
        Start-CommandInShell -CommandText $commandTextBox.Text -Shell $shellCombo.SelectedItem -RunAsAdmin $adminCheck.Checked
        $dialog.Close()
    })
    $dialog.Controls.Add($runBtn)

    $cancelBtn = New-Object System.Windows.Forms.Button
    $cancelBtn.Text = "Cancel"
    $cancelBtn.Location = New-Object System.Drawing.Point(730, 232)
    $cancelBtn.Size = New-Object System.Drawing.Size(130, 38)
    $cancelBtn.FlatStyle = "Flat"
    $cancelBtn.BackColor = "#e2e8f0"
    $cancelBtn.ForeColor = "#0f172a"
    $cancelBtn.Add_Click({
        $dialog.Close()
    })
    $dialog.Controls.Add($cancelBtn)

    $dialog.ShowDialog() | Out-Null
}

function Show-ADCheatSheet {
    param(
        [string]$DefaultDomain = "domain.local"
    )

    $adForm = New-Object System.Windows.Forms.Form
    $adForm.Text = "Active Directory Command Cheatsheet"
    $adForm.Size = New-Object System.Drawing.Size(980, 700)
    $adForm.StartPosition = "CenterParent"
    $adForm.FormBorderStyle = "FixedDialog"
    $adForm.MaximizeBox = $false
    $adForm.MinimizeBox = $false
    $adForm.BackColor = "#e2e8f0"

    $topPanel = New-Object System.Windows.Forms.Panel
    $topPanel.Size = New-Object System.Drawing.Size(980, 65)
    $topPanel.Location = New-Object System.Drawing.Point(0, 0)
    $topPanel.BackColor = "#0f172a"
    $adForm.Controls.Add($topPanel)

    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Text = "Active Directory Command Cheatsheet"
    $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
    $titleLabel.ForeColor = "White"
    $titleLabel.Location = New-Object System.Drawing.Point(20, 15)
    $titleLabel.AutoSize = $true
    $topPanel.Controls.Add($titleLabel)

    $copyBtn = New-Object System.Windows.Forms.Button
    $copyBtn.Text = "Copy All"
    $copyBtn.Location = New-Object System.Drawing.Point(20, 82)
    $copyBtn.Size = New-Object System.Drawing.Size(120, 34)
    $copyBtn.BackColor = "#10b981"
    $copyBtn.ForeColor = "White"
    $copyBtn.FlatStyle = "Flat"
    $copyBtn.FlatAppearance.BorderSize = 0
    $copyBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $copyBtn.Cursor = "Hand"
    $adForm.Controls.Add($copyBtn)

    $scrollPanel = New-Object System.Windows.Forms.Panel
    $scrollPanel.Location = New-Object System.Drawing.Point(20, 135)
    $scrollPanel.Size = New-Object System.Drawing.Size(930, 520)
    $scrollPanel.AutoScroll = $true
    $scrollPanel.BorderStyle = "FixedSingle"
    $scrollPanel.BackColor = "#f8fafc"
    $adForm.Controls.Add($scrollPanel)

    $buttonContainer = New-Object System.Windows.Forms.FlowLayoutPanel
    $buttonContainer.Dock = [System.Windows.Forms.DockStyle]::Fill
    $buttonContainer.AutoScroll = $true
    $buttonContainer.WrapContents = $false
    $buttonContainer.FlowDirection = [System.Windows.Forms.FlowDirection]::TopDown
    $buttonContainer.Padding = New-Object System.Windows.Forms.Padding(8)
    $buttonContainer.BackColor = "#f8fafc"
    $scrollPanel.Controls.Add($buttonContainer)

    $commandEditBox = New-Object System.Windows.Forms.TextBox
    $commandEditBox.Multiline = $true
    $commandEditBox.ScrollBars = "Vertical"
    $commandEditBox.Location = New-Object System.Drawing.Point(20, 660)
    $commandEditBox.Size = New-Object System.Drawing.Size(760, 120)
    $commandEditBox.Font = New-Object System.Drawing.Font("Consolas", 9)
    $commandEditBox.BackColor = "#ffffff"
    $commandEditBox.BorderStyle = "FixedSingle"
    $adForm.Controls.Add($commandEditBox)

    $shellLabel = New-Object System.Windows.Forms.Label
    $shellLabel.Text = "Shell:"
    $shellLabel.Location = New-Object System.Drawing.Point(20, 790)
    $shellLabel.Size = New-Object System.Drawing.Size(50, 20)
    $shellLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $adForm.Controls.Add($shellLabel)

    $shellSelect = New-Object System.Windows.Forms.ComboBox
    $shellSelect.Location = New-Object System.Drawing.Point(70, 786)
    $shellSelect.Size = New-Object System.Drawing.Size(110, 24)
    $shellSelect.DropDownStyle = "DropDownList"
    $shellSelect.Items.AddRange(@("PowerShell", "CMD"))
    $shellSelect.SelectedIndex = 0
    $adForm.Controls.Add($shellSelect)

    $adminCheck = New-Object System.Windows.Forms.CheckBox
    $adminCheck.Text = "Run as Administrator"
    $adminCheck.Location = New-Object System.Drawing.Point(200, 786)
    $adminCheck.Size = New-Object System.Drawing.Size(180, 24)
    $adminCheck.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $adForm.Controls.Add($adminCheck)

    $runNowBtn = New-Object System.Windows.Forms.Button
    $runNowBtn.Location = New-Object System.Drawing.Point(790, 660)
    $runNowBtn.Size = New-Object System.Drawing.Size(160, 120)
    $runNowBtn.Text = "Run Command"
    $runNowBtn.BackColor = "#2563eb"
    $runNowBtn.ForeColor = "White"
    $runNowBtn.FlatStyle = "Flat"
    $runNowBtn.FlatAppearance.BorderSize = 0
    $runNowBtn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $runNowBtn.Cursor = "Hand"
    $runNowBtn.Add_Click({
        Start-CommandInShell -CommandText $commandEditBox.Text -Shell $shellSelect.SelectedItem -RunAsAdmin $adminCheck.Checked
    })
    $adForm.Controls.Add($runNowBtn)

    $executeCommand = {
        param([string]$commandText)

        $trimmedCommand = $commandText.Trim()
        if ([string]::IsNullOrWhiteSpace($trimmedCommand)) {
            return
        }

        $commandEditBox.Text = $trimmedCommand

        try {
            Start-Process powershell.exe -Verb RunAs -ArgumentList @('-NoExit', '-NoLogo', '-Command', $trimmedCommand) | Out-Null
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Error: $($_.Exception.Message)", "Execution failed", "OK", "Error") | Out-Null
        }
    }

    $populateButtons = {
        foreach ($control in $buttonContainer.Controls) {
            $control.Dispose()
        }

        $catalog = Get-ADCommandCatalog -DomainName $DefaultDomain
        $sections = @(
            "DOMAIN CONTROLLER & DOMAIN INFO",
            "USER MANAGEMENT",
            "GROUP MANAGEMENT",
            "ORGANIZATIONAL UNIT MANAGEMENT",
            "COMPUTER MANAGEMENT",
            "DNS MANAGEMENT",
            "SEARCHING & REPORTING",
            "AD SITE & SERVICES",
            "AUTOMATION & TROUBLESHOOTING",
            "COMMON TARGETS & PATHS"
        )

        foreach ($section in $sections) {
            $header = New-Object System.Windows.Forms.Label
            $header.Text = $section
            $header.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
            $header.ForeColor = "#0f172a"
            $header.AutoSize = $true
            $header.Margin = New-Object System.Windows.Forms.Padding(0, 10, 0, 6)
            $buttonContainer.Controls.Add($header)

            foreach ($entry in $catalog[$section]) {
                $card = New-Object System.Windows.Forms.Panel
                $card.Size = New-Object System.Drawing.Size(860, 82)
                $card.BorderStyle = "FixedSingle"
                $card.BackColor = "#ffffff"
                $card.Margin = New-Object System.Windows.Forms.Padding(0, 4, 0, 8)
                $card.Padding = New-Object System.Windows.Forms.Padding(12, 8, 12, 8)

                $accent = New-Object System.Windows.Forms.Panel
                $accent.Size = New-Object System.Drawing.Size(5, 60)
                $accent.Location = New-Object System.Drawing.Point(0, 0)
                $accent.BackColor = "#2563eb"
                $accent.Dock = [System.Windows.Forms.DockStyle]::Left
                $card.Controls.Add($accent)

                $btn = New-Object System.Windows.Forms.Button
                $btn.Text = $entry.Command
                $btn.Location = New-Object System.Drawing.Point(20, 8)
                $btn.Size = New-Object System.Drawing.Size(820, 34)
                $btn.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
                $btn.FlatStyle = "Flat"
                $btn.FlatAppearance.BorderSize = 0
                $btn.BackColor = "#f8fafc"
                $btn.ForeColor = "#0f172a"
                $btn.Font = New-Object System.Drawing.Font("Consolas", 9, [System.Drawing.FontStyle]::Bold)
                $btn.Padding = New-Object System.Windows.Forms.Padding(8, 0, 0, 0)
                $btn.Add_Click({
                    param($sender, $eventArgs)
                    Show-CommandEditorDialog -CommandText $sender.Text
                })
                $card.Controls.Add($btn)

                $desc = New-Object System.Windows.Forms.Label
                $desc.Text = $entry.Description
                $desc.Location = New-Object System.Drawing.Point(20, 46)
                $desc.Size = New-Object System.Drawing.Size(820, 24)
                $desc.ForeColor = "#475569"
                $desc.Font = New-Object System.Drawing.Font("Segoe UI", 9)
                $desc.AutoEllipsis = $true
                $card.Controls.Add($desc)

                $buttonContainer.Controls.Add($card)
            }
        }
    }

    $copyBtn.Add_Click({
        $allCommands = Get-ADCheatSheetText -DomainName $DefaultDomain
        if (-not [string]::IsNullOrWhiteSpace($allCommands)) {
            [System.Windows.Forms.Clipboard]::SetText($allCommands)
            [System.Windows.Forms.MessageBox]::Show("The full cheat sheet was copied to your clipboard.", "Copied", "OK", "Information") | Out-Null
        }
    })

    $populateButtons.Invoke()
    $adForm.ShowDialog()
}

# Function to run commands
function Run-Command {
    param([string]$command)
    Append-Output "--- Running: $command ---"
    try {
        $result = & cmd.exe /c $command 2>&1
        Append-Output ($result | Out-String)
    } catch {
        Append-Output "Error: $_"
    }
    Append-Output "--- Done ---"
}

# Primary Button Color
$primaryColor = "#4f46e5"
$secondaryColor = "#0ea5e9"
$softGray = "#e2e8f0"

# Column 1 (Left)
$btn1 = New-Object System.Windows.Forms.Button
$btn1.Text = "1. Show IP Configuration"
$btn1.Location = New-Object System.Drawing.Point(45, 115)
$btn1.Size = New-Object System.Drawing.Size(240, 44)
Set-ModernButtonStyle -Button $btn1 -BackColor $primaryColor -ForeColor "White"
$btn1.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$btn1.Add_Click({ Run-Command "ipconfig /all" })
$form.Controls.Add($btn1)

$btn2 = New-Object System.Windows.Forms.Button
$btn2.Text = "2. Flush DNS Cache"
$btn2.Location = New-Object System.Drawing.Point(45, 167)
$btn2.Size = New-Object System.Drawing.Size(240, 44)
Set-ModernButtonStyle -Button $btn2 -BackColor $primaryColor -ForeColor "White"
$btn2.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$btn2.Add_Click({ Run-Command "ipconfig /flushdns" })
$form.Controls.Add($btn2)

$btn3 = New-Object System.Windows.Forms.Button
$btn3.Text = "3. Release IP Address"
$btn3.Location = New-Object System.Drawing.Point(45, 219)
$btn3.Size = New-Object System.Drawing.Size(240, 44)
Set-ModernButtonStyle -Button $btn3 -BackColor $primaryColor -ForeColor "White"
$btn3.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$btn3.Add_Click({ Run-Command "ipconfig /release" })
$form.Controls.Add($btn3)

$btn4 = New-Object System.Windows.Forms.Button
$btn4.Text = "4. Renew IP Address"
$btn4.Location = New-Object System.Drawing.Point(45, 271)
$btn4.Size = New-Object System.Drawing.Size(240, 44)
Set-ModernButtonStyle -Button $btn4 -BackColor $primaryColor -ForeColor "White"
$btn4.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$btn4.Add_Click({ Run-Command "ipconfig /renew" })
$form.Controls.Add($btn4)

$btn9 = New-Object System.Windows.Forms.Button
$btn9.Text = "9. Network Settings"
$btn9.Location = New-Object System.Drawing.Point(45, 323)
$btn9.Size = New-Object System.Drawing.Size(240, 44)
Set-ModernButtonStyle -Button $btn9 -BackColor $primaryColor -ForeColor "White"
$btn9.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$btn9.Add_Click({ Start-Process "ncpa.cpl" })
$form.Controls.Add($btn9)

# Column 2 (Right)
$btn5 = New-Object System.Windows.Forms.Button
$btn5.Text = "5. Reset Winsock"
$btn5.Location = New-Object System.Drawing.Point(315, 115)
$btn5.Size = New-Object System.Drawing.Size(240, 44)
Set-ModernButtonStyle -Button $btn5 -BackColor $primaryColor -ForeColor "White"
$btn5.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$btn5.Add_Click({ 
    Run-Command "netsh winsock reset"
    Append-Output "Note: Please restart your computer for changes to take effect"
})
$form.Controls.Add($btn5)

$btn6 = New-Object System.Windows.Forms.Button
$btn6.Text = "6. Reset TCP/IP Stack"
$btn6.Location = New-Object System.Drawing.Point(315, 167)
$btn6.Size = New-Object System.Drawing.Size(240, 44)
Set-ModernButtonStyle -Button $btn6 -BackColor $primaryColor -ForeColor "White"
$btn6.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$btn6.Add_Click({ 
    Run-Command "netsh int ip reset"
    Append-Output "Note: Please restart your computer for changes to take effect"
})
$form.Controls.Add($btn6)

$btn7 = New-Object System.Windows.Forms.Button
$btn7.Text = "7. Ping Google (8.8.8.8)"
$btn7.Location = New-Object System.Drawing.Point(315, 219)
$btn7.Size = New-Object System.Drawing.Size(240, 44)
Set-ModernButtonStyle -Button $btn7 -BackColor $secondaryColor -ForeColor "White"
$btn7.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$btn7.Add_Click({ Run-Command "ping -n 4 8.8.8.8" })
$form.Controls.Add($btn7)

$btn8 = New-Object System.Windows.Forms.Button
$btn8.Text = "8. Network Statistics"
$btn8.Location = New-Object System.Drawing.Point(315, 271)
$btn8.Size = New-Object System.Drawing.Size(240, 44)
Set-ModernButtonStyle -Button $btn8 -BackColor $primaryColor -ForeColor "White"
$btn8.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$btn8.Add_Click({ Run-Command "netstat -ano" })
$form.Controls.Add($btn8)

$btn10 = New-Object System.Windows.Forms.Button
$btn10.Text = "10. Wi-Fi Settings"
$btn10.Location = New-Object System.Drawing.Point(315, 323)
$btn10.Size = New-Object System.Drawing.Size(240, 44)
Set-ModernButtonStyle -Button $btn10 -BackColor $primaryColor -ForeColor "White"
$btn10.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$btn10.Add_Click({ Start-Process "ms-settings:network-wifi" })
$form.Controls.Add($btn10)

# Full Width Buttons
$btn11 = New-Object System.Windows.Forms.Button
$btn11.Text = "11. Full Network Repair"
$btn11.Location = New-Object System.Drawing.Point(45, 375)
$btn11.Size = New-Object System.Drawing.Size(510, 44)
Set-ModernButtonStyle -Button $btn11 -BackColor "#f59e0b" -ForeColor "White" -Large $true
$btn11.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$btn11.Add_Click({ 
    Append-Output "=== Starting Full Network Repair ==="
    Run-Command "ipconfig /flushdns"
    Run-Command "ipconfig /release"
    Run-Command "ipconfig /renew"
    Run-Command "netsh winsock reset"
    Run-Command "netsh int ip reset"
    Append-Output "=== Full Network Repair Complete! ==="
    Append-Output "Note: Please restart your computer for changes to take effect"
})
$form.Controls.Add($btn11)

$btn12 = New-Object System.Windows.Forms.Button
$btn12.Text = "12. Windows Optimization"
$btn12.Location = New-Object System.Drawing.Point(45, 427)
$btn12.Size = New-Object System.Drawing.Size(510, 44)
Set-ModernButtonStyle -Button $btn12 -BackColor "#10b981" -ForeColor "White" -Large $true
$btn12.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$btn12.Add_Click({ 
    Append-Output "=== Starting Windows Optimization ==="
    Append-Output "Clearing temporary files..."
    Run-Command "del /q /s /f %temp%\*.* 2>nul"
    Append-Output "Note: Some temporary files cleared!"
    Append-Output "=== Optimization Complete! ==="
    Append-Output "Note: For full optimization, restart your computer"
})
$form.Controls.Add($btn12)

$btn13 = New-Object System.Windows.Forms.Button
$btn13.Text = "13. Active Directory Cheat Sheet"
$btn13.Location = New-Object System.Drawing.Point(45, 480)
$btn13.Size = New-Object System.Drawing.Size(510, 44)
Set-ModernButtonStyle -Button $btn13 -BackColor "#7c3aed" -ForeColor "White" -Large $true
$btn13.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$btn13.Add_Click({
    Show-ADCheatSheet -DefaultDomain "domain.local"
})
$form.Controls.Add($btn13)

# Show the form
Append-Output "Welcome to the IT Infrastructure Toolkit"
Append-Output "Professional tools for system administration"
Append-Output ""
Append-Output "Click any button to get started!"
$form.ShowDialog()
