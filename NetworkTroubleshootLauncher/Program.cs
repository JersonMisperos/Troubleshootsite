using System;
using System.Diagnostics;
using System.IO;

var scriptPath = Path.Combine(AppContext.BaseDirectory, "NetworkTroubleshoot.ps1");

if (!File.Exists(scriptPath))
{
    var fallback = Path.Combine(Directory.GetCurrentDirectory(), "NetworkTroubleshoot.ps1");
    if (File.Exists(fallback))
    {
        scriptPath = fallback;
    }
}

if (!File.Exists(scriptPath))
{
    Console.WriteLine("Missing NetworkTroubleshoot.ps1 in the application folder.");
    Console.WriteLine($"Expected location: {scriptPath}");
    Environment.Exit(1);
}

var startInfo = new ProcessStartInfo
{
    FileName = "powershell.exe",
    Arguments = $"-NoProfile -ExecutionPolicy Bypass -File \"{scriptPath}\"",
    UseShellExecute = true,
    Verb = "RunAs"
};

Process.Start(startInfo);
