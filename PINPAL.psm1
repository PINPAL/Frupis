#requires -Version 2 -Modules posh-git

function Write-Theme {

    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )
    
    $prompt = ''
    
    if ($sl.PromptSymbols.StartSymbol -ne ' ') {
        $prompt += Write-Prompt -Object $sl.PromptSymbols.StartSymbol -ForegroundColor $sl.Colors.LightForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
    }

    #check the last command state and indicate if failed
    If ($lastCommandFailed) {
        $prompt += Write-Prompt -Object " ! " -ForegroundColor $sl.Colors.LightForegroundColor -BackgroundColor $sl.Colors.CommandFailedIconForegroundColor
        # Writes the postfix (>) to the prompt
        $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $sl.Colors.CommandFailedIconForegroundColor -BackgroundColor $sl.Colors.HostnameBackgroundColor
    }

    if (Test-NotDefaultUser($sl.CurrentUser)) {
        # Writes hostname
        $prompt += Write-Prompt -Object " $($sl.CurrentHostname) " -ForegroundColor $sl.Colors.LightForegroundColor -BackgroundColor $sl.Colors.HostnameBackgroundColor
        # Writes the postfix (>) to the prompt
        $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $sl.Colors.HostnameBackgroundColor -BackgroundColor $sl.Colors.UsernameBackgroundColor
        # Writes the user symbol
        $prompt += Write-Prompt -Object " $($sl.PromptSymbols.UserSymbol) " -ForegroundColor $sl.Colors.LightForegroundColor -BackgroundColor $sl.Colors.UsernameBackgroundColor
        # Writes username
        $prompt += Write-Prompt -Object "$($sl.CurrentUser) " -ForegroundColor $sl.Colors.LightForegroundColor -BackgroundColor $sl.Colors.UsernameBackgroundColor
    }

    # Writes the postfix (>) to the prompt
    $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $sl.Colors.UsernameBackgroundColor -BackgroundColor $sl.Colors.LightForegroundColor
    
    #check for elevated prompt
    If (Test-Administrator) {
        # Writes the elevated prompt indicator symbol
        $prompt += Write-Prompt -Object " $($sl.PromptSymbols.UnlockedSymbol) " -ForegroundColor $sl.Colors.DarkForegroundColor -BackgroundColor $sl.Colors.LightForegroundColor
    }
    else {
        # Writes the locked prompt indicator symbol
        $prompt += Write-Prompt -Object " $($sl.PromptSymbols.LockedSymbol) " -ForegroundColor $sl.Colors.DarkForegroundColor -BackgroundColor $sl.Colors.LightForegroundColor
    }

    # Writes the postfix (>) to the prompt
    $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $sl.Colors.LightForegroundColor -BackgroundColor $sl.Colors.DriveBackgroundColor

    # Writes the drive letter
    $prompt += Write-Prompt -Object ' ' -ForegroundColor $sl.Colors.LightForegroundColor -BackgroundColor $sl.Colors.DriveBackgroundColor
    $prompt += Write-Prompt -Object ($pwd.drive.name) -ForegroundColor $sl.Colors.LightForegroundColor -BackgroundColor $sl.Colors.DriveBackgroundColor
    $prompt += Write-Prompt -Object ': ' -ForegroundColor $sl.Colors.LightForegroundColor -BackgroundColor $sl.Colors.DriveBackgroundColor

    # Writes the postfix (>) to the prompt
    $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $sl.Colors.DriveBackgroundColor -BackgroundColor $sl.Colors.DirectoryBackgroundColor

    # Finds current directory
    $directory = (Get-FullPath -dir $pwd)
    if ($directory.length -gt 2) {
        $directory = $directory.substring(3)
    }
    else {
        $directory = '~'
    }
    # Writes the directory
    $prompt += Write-Prompt -Object " $($sl.PromptSymbols.FolderSymbol) " -ForegroundColor $sl.Colors.LightForegroundColor -BackgroundColor $sl.Colors.DirectoryBackgroundColor
    $prompt += Write-Prompt -Object "$directory" -ForegroundColor $sl.Colors.LightForegroundColor -BackgroundColor $sl.Colors.DirectoryBackgroundColor
    $prompt += Write-Prompt -Object ' ' -ForegroundColor $sl.Colors.LightForegroundColor -BackgroundColor $sl.Colors.DirectoryBackgroundColor
    $lastColor = $sl.Colors.DirectoryBackgroundColor

    $status = Get-VCSStatus
    if ($status) {
        $themeInfo = Get-VcsInfo -status ($status)
        $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $sl.Colors.DirectoryBackgroundColor -BackgroundColor $themeInfo.BackgroundColor
        $prompt += Write-Prompt -Object " $($themeInfo.VcInfo) " -BackgroundColor $themeInfo.BackgroundColor -ForegroundColor $sl.Colors.DarkForegroundColor
        $lastColor = $themeInfo.BackgroundColor
    }

    # Writes the postfix (>) to the prompt
    $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $lastColor
    $prompt += ' '
    $prompt
}

$sl = $global:ThemeSettings #local settings
# Symbols
$sl.PromptSymbols.UserSymbol = [char]::ConvertFromUtf32(0xf007)
$sl.PromptSymbols.FolderSymbol = [char]::ConvertFromUtf32(0xf07c)
$sl.PromptSymbols.UnlockedSymbol = [char]::ConvertFromUtf32(0xf13e)
$sl.PromptSymbols.LockedSymbol = [char]::ConvertFromUtf32(0xf023)
$sl.PromptSymbols.SegmentForwardSymbol = [char]::ConvertFromUtf32(0xE0B0)
# Colors
$sl.Colors.DarkForegroundColor = [ConsoleColor]::Black
$sl.Colors.LightForegroundColor = [ConsoleColor]::White
$sl.Colors.HostnameBackgroundColor = [System.ConsoleColor]::Gray
$sl.Colors.UsernameBackgroundColor = [System.ConsoleColor]::DarkGray
$sl.Colors.DirectoryBackgroundColor = [System.ConsoleColor]::Blue
$sl.Colors.DriveBackgroundColor = [System.ConsoleColor]::DarkBlue