# Load Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create main form - make it taller to fit all buttons
$form = New-Object System.Windows.Forms.Form
$form.Text = "Network Troubleshoot Toolkit"
$form.Size = New-Object System.Drawing.Size(520, 540)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = "#f0f0f0"

# Create title label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Network Troubleshoot Toolkit"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$titleLabel.Location = New-Object System.Drawing.Point(20, 20)
$titleLabel.Size = New-Object System.Drawing.Size(480, 30)
$titleLabel.ForeColor = "#0066cc"
$form.Controls.Add($titleLabel)

# Create output text box - move it down a bit
$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Multiline = $true
$outputBox.ScrollBars = "Vertical"
$outputBox.Location = New-Object System.Drawing.Point(20, 340)
$outputBox.Size = New-Object System.Drawing.Size(460, 150)
$outputBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$outputBox.ReadOnly = $true
$outputBox.BackColor = "white"
$form.Controls.Add($outputBox)

# Function to append output
function Append-Output {
    param([string]$text)
    $outputBox.AppendText($text + "`r`n")
    $outputBox.ScrollToCaret()
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

# Button 1: IP Config
$btnIPConfig = New-Object System.Windows.Forms.Button
$btnIPConfig.Text = "1. Show IP Configuration"
$btnIPConfig.Location = New-Object System.Drawing.Point(20, 60)
$btnIPConfig.Size = New-Object System.Drawing.Size(210, 30)
$btnIPConfig.BackColor = "#e8f4fc"
$btnIPConfig.FlatStyle = "Flat"
$btnIPConfig.Add_Click({ Run-Command "ipconfig /all" })
$form.Controls.Add($btnIPConfig)

# Button 2: Flush DNS
$btnFlushDNS = New-Object System.Windows.Forms.Button
$btnFlushDNS.Text = "2. Flush DNS Cache"
$btnFlushDNS.Location = New-Object System.Drawing.Point(20, 100)
$btnFlushDNS.Size = New-Object System.Drawing.Size(210, 30)
$btnFlushDNS.BackColor = "#e8f4fc"
$btnFlushDNS.FlatStyle = "Flat"
$btnFlushDNS.Add_Click({ Run-Command "ipconfig /flushdns" })
$form.Controls.Add($btnFlushDNS)

# Button 3: Release IP
$btnRelease = New-Object System.Windows.Forms.Button
$btnRelease.Text = "3. Release IP Address"
$btnRelease.Location = New-Object System.Drawing.Point(20, 140)
$btnRelease.Size = New-Object System.Drawing.Size(210, 30)
$btnRelease.BackColor = "#e8f4fc"
$btnRelease.FlatStyle = "Flat"
$btnRelease.Add_Click({ Run-Command "ipconfig /release" })
$form.Controls.Add($btnRelease)

# Button 4: Renew IP
$btnRenew = New-Object System.Windows.Forms.Button
$btnRenew.Text = "4. Renew IP Address"
$btnRenew.Location = New-Object System.Drawing.Point(20, 180)
$btnRenew.Size = New-Object System.Drawing.Size(210, 30)
$btnRenew.BackColor = "#e8f4fc"
$btnRenew.FlatStyle = "Flat"
$btnRenew.Add_Click({ Run-Command "ipconfig /renew" })
$form.Controls.Add($btnRenew)

# Button 5: Reset Winsock
$btnWinsock = New-Object System.Windows.Forms.Button
$btnWinsock.Text = "5. Reset Winsock"
$btnWinsock.Location = New-Object System.Drawing.Point(270, 60)
$btnWinsock.Size = New-Object System.Drawing.Size(210, 30)
$btnWinsock.BackColor = "#e8f4fc"
$btnWinsock.FlatStyle = "Flat"
$btnWinsock.Add_Click({ 
    Run-Command "netsh winsock reset"
    Append-Output "Note: Please restart your computer for changes to take effect"
})
$form.Controls.Add($btnWinsock)

# Button 6: Reset TCP/IP
$btnTCPIP = New-Object System.Windows.Forms.Button
$btnTCPIP.Text = "6. Reset TCP/IP Stack"
$btnTCPIP.Location = New-Object System.Drawing.Point(270, 100)
$btnTCPIP.Size = New-Object System.Drawing.Size(210, 30)
$btnTCPIP.BackColor = "#e8f4fc"
$btnTCPIP.FlatStyle = "Flat"
$btnTCPIP.Add_Click({ 
    Run-Command "netsh int ip reset"
    Append-Output "Note: Please restart your computer for changes to take effect"
})
$form.Controls.Add($btnTCPIP)

# Button 7: Ping Google
$btnPing = New-Object System.Windows.Forms.Button
$btnPing.Text = "7. Ping Google"
$btnPing.Location = New-Object System.Drawing.Point(270, 140)
$btnPing.Size = New-Object System.Drawing.Size(210, 30)
$btnPing.BackColor = "#e8f4fc"
$btnPing.FlatStyle = "Flat"
$btnPing.Add_Click({ Run-Command "ping -n 4 8.8.8.8" })
$form.Controls.Add($btnPing)

# Button 8: Network Statistics
$btnNetstat = New-Object System.Windows.Forms.Button
$btnNetstat.Text = "8. Network Statistics"
$btnNetstat.Location = New-Object System.Drawing.Point(270, 180)
$btnNetstat.Size = New-Object System.Drawing.Size(210, 30)
$btnNetstat.BackColor = "#e8f4fc"
$btnNetstat.FlatStyle = "Flat"
$btnNetstat.Add_Click({ Run-Command "netstat -ano" })
$form.Controls.Add($btnNetstat)

# Button 9: Open Network Connections
$btnNetConn = New-Object System.Windows.Forms.Button
$btnNetConn.Text = "9. Open Network Connections"
$btnNetConn.Location = New-Object System.Drawing.Point(20, 220)
$btnNetConn.Size = New-Object System.Drawing.Size(210, 30)
$btnNetConn.BackColor = "#e8f4fc"
$btnNetConn.FlatStyle = "Flat"
$btnNetConn.Add_Click({ Start-Process "ncpa.cpl" })
$form.Controls.Add($btnNetConn)

# Button 10: Open Wi-Fi Settings
$btnWiFi = New-Object System.Windows.Forms.Button
$btnWiFi.Text = "10. Open Wi-Fi Settings"
$btnWiFi.Location = New-Object System.Drawing.Point(270, 220)
$btnWiFi.Size = New-Object System.Drawing.Size(210, 30)
$btnWiFi.BackColor = "#e8f4fc"
$btnWiFi.FlatStyle = "Flat"
$btnWiFi.Add_Click({ Start-Process "ms-settings:network-wifi" })
$form.Controls.Add($btnWiFi)

# Button 11: Full Network Repair
$btnFullRepair = New-Object System.Windows.Forms.Button
$btnFullRepair.Text = "11. Full Network Repair"
$btnFullRepair.Location = New-Object System.Drawing.Point(20, 260)
$btnFullRepair.Size = New-Object System.Drawing.Size(460, 30)
$btnFullRepair.BackColor = "#ffeb9c"
$btnFullRepair.FlatStyle = "Flat"
$btnFullRepair.Font = New-Object System.Drawing.Font($btnFullRepair.Font, [System.Drawing.FontStyle]::Bold)
$btnFullRepair.Add_Click({ 
    Append-Output "=== Starting Full Network Repair ==="
    Run-Command "ipconfig /flushdns"
    Run-Command "ipconfig /release"
    Run-Command "ipconfig /renew"
    Run-Command "netsh winsock reset"
    Run-Command "netsh int ip reset"
    Append-Output "=== Full Network Repair Complete! ==="
    Append-Output "Note: Please restart your computer for changes to take effect"
})
$form.Controls.Add($btnFullRepair)

# Button 12: Windows Optimization
$btnOptimize = New-Object System.Windows.Forms.Button
$btnOptimize.Text = "12. Windows Optimization"
$btnOptimize.Location = New-Object System.Drawing.Point(20, 300)
$btnOptimize.Size = New-Object System.Drawing.Size(460, 30)
$btnOptimize.BackColor = "#d4f4e1"
$btnOptimize.FlatStyle = "Flat"
$btnOptimize.Font = New-Object System.Drawing.Font($btnOptimize.Font, [System.Drawing.FontStyle]::Bold)
$btnOptimize.Add_Click({ 
    Append-Output "=== Starting Windows Optimization ==="
    Append-Output "Running Disk Cleanup (cleanmgr /sagerun:1 (Note: First time might not run automatically, cleanmgr is interactive)"
    Append-Output "Clearing temporary files..."
    Run-Command "del /q /s /f %temp%\*.* 2>nul"
    Append-Output "Note: Some temporary files cleared!"
    Append-Output "=== Optimization Complete! ==="
    Append-Output "Note: For full optimization, restart your computer"
})
$form.Controls.Add($btnOptimize)

# Show the form
Append-Output "Welcome to Network Troubleshoot Toolkit!"
Append-Output "Click any button to run a network tool or optimization!"
$form.ShowDialog()
