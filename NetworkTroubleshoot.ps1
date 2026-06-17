# Load Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create main form - PERFECT FIT, NO OVERLAP
$form = New-Object System.Windows.Forms.Form
$form.Text = "Network & Optimization Toolkit"
$form.Size = New-Object System.Drawing.Size(600, 700)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = "#f1f5f9"

# Create Header Panel
$headerPanel = New-Object System.Windows.Forms.Panel
$headerPanel.Size = New-Object System.Drawing.Size(600, 95)
$headerPanel.Location = New-Object System.Drawing.Point(0, 0)
$headerPanel.BackColor = "#4338ca"
$form.Controls.Add($headerPanel)

# Add Main Title
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Network & Optimization Toolkit"
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

# Create Output Box - NOW POSITIONED BELOW BUTTON 12
$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Multiline = $true
$outputBox.ScrollBars = "Vertical"
$outputBox.Location = New-Object System.Drawing.Point(45, 485)
$outputBox.Size = New-Object System.Drawing.Size(510, 170)
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

# Column 1 (Left)
$btn1 = New-Object System.Windows.Forms.Button
$btn1.Text = "1. Show IP Configuration"
$btn1.Location = New-Object System.Drawing.Point(45, 115)
$btn1.Size = New-Object System.Drawing.Size(240, 44)
$btn1.BackColor = $primaryColor
$btn1.ForeColor = "White"
$btn1.FlatStyle = "Flat"
$btn1.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$btn1.FlatAppearance.BorderSize = 0
$btn1.Cursor = "Hand"
$btn1.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$btn1.Add_Click({ Run-Command "ipconfig /all" })
$form.Controls.Add($btn1)

$btn2 = New-Object System.Windows.Forms.Button
$btn2.Text = "2. Flush DNS Cache"
$btn2.Location = New-Object System.Drawing.Point(45, 167)
$btn2.Size = New-Object System.Drawing.Size(240, 44)
$btn2.BackColor = $primaryColor
$btn2.ForeColor = "White"
$btn2.FlatStyle = "Flat"
$btn2.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$btn2.FlatAppearance.BorderSize = 0
$btn2.Cursor = "Hand"
$btn2.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$btn2.Add_Click({ Run-Command "ipconfig /flushdns" })
$form.Controls.Add($btn2)

$btn3 = New-Object System.Windows.Forms.Button
$btn3.Text = "3. Release IP Address"
$btn3.Location = New-Object System.Drawing.Point(45, 219)
$btn3.Size = New-Object System.Drawing.Size(240, 44)
$btn3.BackColor = $primaryColor
$btn3.ForeColor = "White"
$btn3.FlatStyle = "Flat"
$btn3.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$btn3.FlatAppearance.BorderSize = 0
$btn3.Cursor = "Hand"
$btn3.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$btn3.Add_Click({ Run-Command "ipconfig /release" })
$form.Controls.Add($btn3)

$btn4 = New-Object System.Windows.Forms.Button
$btn4.Text = "4. Renew IP Address"
$btn4.Location = New-Object System.Drawing.Point(45, 271)
$btn4.Size = New-Object System.Drawing.Size(240, 44)
$btn4.BackColor = $primaryColor
$btn4.ForeColor = "White"
$btn4.FlatStyle = "Flat"
$btn4.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$btn4.FlatAppearance.BorderSize = 0
$btn4.Cursor = "Hand"
$btn4.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$btn4.Add_Click({ Run-Command "ipconfig /renew" })
$form.Controls.Add($btn4)

$btn9 = New-Object System.Windows.Forms.Button
$btn9.Text = "9. Network Settings"
$btn9.Location = New-Object System.Drawing.Point(45, 323)
$btn9.Size = New-Object System.Drawing.Size(240, 44)
$btn9.BackColor = $primaryColor
$btn9.ForeColor = "White"
$btn9.FlatStyle = "Flat"
$btn9.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$btn9.FlatAppearance.BorderSize = 0
$btn9.Cursor = "Hand"
$btn9.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$btn9.Add_Click({ Start-Process "ncpa.cpl" })
$form.Controls.Add($btn9)

# Column 2 (Right)
$btn5 = New-Object System.Windows.Forms.Button
$btn5.Text = "5. Reset Winsock"
$btn5.Location = New-Object System.Drawing.Point(315, 115)
$btn5.Size = New-Object System.Drawing.Size(240, 44)
$btn5.BackColor = $primaryColor
$btn5.ForeColor = "White"
$btn5.FlatStyle = "Flat"
$btn5.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$btn5.FlatAppearance.BorderSize = 0
$btn5.Cursor = "Hand"
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
$btn6.BackColor = $primaryColor
$btn6.ForeColor = "White"
$btn6.FlatStyle = "Flat"
$btn6.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$btn6.FlatAppearance.BorderSize = 0
$btn6.Cursor = "Hand"
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
$btn7.BackColor = $primaryColor
$btn7.ForeColor = "White"
$btn7.FlatStyle = "Flat"
$btn7.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$btn7.FlatAppearance.BorderSize = 0
$btn7.Cursor = "Hand"
$btn7.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$btn7.Add_Click({ Run-Command "ping -n 4 8.8.8.8" })
$form.Controls.Add($btn7)

$btn8 = New-Object System.Windows.Forms.Button
$btn8.Text = "8. Network Statistics"
$btn8.Location = New-Object System.Drawing.Point(315, 271)
$btn8.Size = New-Object System.Drawing.Size(240, 44)
$btn8.BackColor = $primaryColor
$btn8.ForeColor = "White"
$btn8.FlatStyle = "Flat"
$btn8.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$btn8.FlatAppearance.BorderSize = 0
$btn8.Cursor = "Hand"
$btn8.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$btn8.Add_Click({ Run-Command "netstat -ano" })
$form.Controls.Add($btn8)

$btn10 = New-Object System.Windows.Forms.Button
$btn10.Text = "10. Wi-Fi Settings"
$btn10.Location = New-Object System.Drawing.Point(315, 323)
$btn10.Size = New-Object System.Drawing.Size(240, 44)
$btn10.BackColor = $primaryColor
$btn10.ForeColor = "White"
$btn10.FlatStyle = "Flat"
$btn10.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$btn10.FlatAppearance.BorderSize = 0
$btn10.Cursor = "Hand"
$btn10.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$btn10.Add_Click({ Start-Process "ms-settings:network-wifi" })
$form.Controls.Add($btn10)

# Full Width Buttons
$btn11 = New-Object System.Windows.Forms.Button
$btn11.Text = "11. Full Network Repair"
$btn11.Location = New-Object System.Drawing.Point(45, 375)
$btn11.Size = New-Object System.Drawing.Size(510, 44)
$btn11.BackColor = "#f59e0b"
$btn11.ForeColor = "White"
$btn11.FlatStyle = "Flat"
$btn11.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btn11.FlatAppearance.BorderSize = 0
$btn11.Cursor = "Hand"
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
$btn12.BackColor = "#10b981"
$btn12.ForeColor = "White"
$btn12.FlatStyle = "Flat"
$btn12.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btn12.FlatAppearance.BorderSize = 0
$btn12.Cursor = "Hand"
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

# Show the form
Append-Output "Welcome to the Network & Optimization Toolkit"
Append-Output "Professional tools for system administration"
Append-Output ""
Append-Output "Click any button to get started!"
$form.ShowDialog()
