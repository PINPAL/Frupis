#requires -Version 2 -Modules posh-git

function Write-Theme {

    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )
    
    $prompt = Set-Newline

    #check the last command state and indicate if failed
    If ($lastCommandFailed) {
        $prompt += Write-Prompt -Object " ! " -ForegroundColor $pp.Colors.LightForegroundColor -BackgroundColor $pp.Colors.CommandFailedIconForegroundColor
        # Writes the postfix (>) to the prompt
        $prompt += Write-Prompt -Object $pp.PromptSymbols.SegmentForwardSymbol -ForegroundColor $pp.Colors.CommandFailedIconForegroundColor -BackgroundColor $pp.Colors.BackgroundColor
        $prompt += Write-Prompt -Object "$($pp.PromptSymbols.SegmentForwardSymbol)" -BackgroundColor $pp.Colors.LightForegroundColor -ForegroundColor $pp.Colors.DarkForegroundColor
    }


    #check for elevated prompt
    If (Test-Administrator) {
        # Writes the elevated prompt indicator symbol
        $prompt += Write-Prompt -Object " $($pp.PromptSymbols.UnlockedSymbol) " -ForegroundColor $pp.Colors.DarkForegroundColor -BackgroundColor $pp.Colors.LightForegroundColor
    }
    else {
        # Writes the locked prompt indicator symbol
        $prompt += Write-Prompt -Object " $($pp.PromptSymbols.LockedSymbol) " -ForegroundColor $pp.Colors.DarkForegroundColor -BackgroundColor $pp.Colors.LightForegroundColor
    }

    # Writes the postfix (>) to the prompt
    $prompt += Write-Prompt -Object $pp.PromptSymbols.SegmentForwardSymbol -ForegroundColor $pp.Colors.LightForegroundColor -BackgroundColor $pp.Colors.HostnameBackgroundColor
    
    if (Test-NotDefaultUser($pp.CurrentUser)) {
        # Writes hostname
        $prompt += Write-Prompt -Object " $($pp.CurrentHostname) " -ForegroundColor $pp.Colors.LightForegroundColor -BackgroundColor $pp.Colors.HostnameBackgroundColor
        # Writes the postfix (>) to the prompt
        $prompt += Write-Prompt -Object $pp.PromptSymbols.SegmentForwardSymbol -ForegroundColor $pp.Colors.HostnameBackgroundColor -BackgroundColor $pp.Colors.UsernameBackgroundColor
        # Writes the user symbol
        $prompt += Write-Prompt -Object " $($pp.PromptSymbols.UserSymbol) " -ForegroundColor $pp.Colors.LightForegroundColor -BackgroundColor $pp.Colors.UsernameBackgroundColor
        # Writes username
        $prompt += Write-Prompt -Object "$($pp.CurrentUser) " -ForegroundColor $pp.Colors.LightForegroundColor -BackgroundColor $pp.Colors.UsernameBackgroundColor
    }

    # Writes the postfix (>) to the prompt
    $prompt += Write-Prompt -Object $pp.PromptSymbols.SegmentForwardSymbol -ForegroundColor $pp.Colors.UsernameBackgroundColor -BackgroundColor $pp.Colors.BackgroundColor
    $prompt += Write-Prompt -Object "$($pp.PromptSymbols.SegmentForwardSymbol)" -BackgroundColor $pp.Colors.DriveBackgroundColor -ForegroundColor $pp.Colors.DarkForegroundColor

    # Writes the drive letter
    $prompt += Write-Prompt -Object ' ' -ForegroundColor $pp.Colors.LightForegroundColor -BackgroundColor $pp.Colors.DriveBackgroundColor
    $prompt += Write-Prompt -Object ($pwd.drive.name) -ForegroundColor $pp.Colors.LightForegroundColor -BackgroundColor $pp.Colors.DriveBackgroundColor
    $prompt += Write-Prompt -Object ': ' -ForegroundColor $pp.Colors.LightForegroundColor -BackgroundColor $pp.Colors.DriveBackgroundColor

    # Writes the postfix (>) to the prompt
    $prompt += Write-Prompt -Object $pp.PromptSymbols.SegmentForwardSymbol -ForegroundColor $pp.Colors.DriveBackgroundColor -BackgroundColor $pp.Colors.DirectoryBackgroundColor

    # Finds current directory
    $directory = (Get-FullPath -dir $pwd)
    if ($directory.length -gt 2) {
        $directory = $directory.substring(3)
    }
    else {
        $directory = '~'
    }
    # Writes the directory
    $prompt += Write-Prompt -Object " $($pp.PromptSymbols.FolderSymbol) " -ForegroundColor $pp.Colors.DarkForegroundColor -BackgroundColor $pp.Colors.DirectoryBackgroundColor
    $prompt += Write-Prompt -Object "$directory" -ForegroundColor $pp.Colors.DarkForegroundColor -BackgroundColor $pp.Colors.DirectoryBackgroundColor
    $prompt += Write-Prompt -Object ' ' -ForegroundColor $pp.Colors.DarkForegroundColor -BackgroundColor $pp.Colors.DirectoryBackgroundColor
    $lastColor = $pp.Colors.DirectoryBackgroundColor

    # Writes the Github prompt
    $status = Get-VCSStatus

    if ($status) {
        # Writes the postfix (>) to the prompt
        $prompt += Write-Prompt -Object $pp.PromptSymbols.SegmentForwardSymbol -ForegroundColor $pp.Colors.DirectoryBackgroundColor -BackgroundColor $pp.Colors.BackgroundColor
        $prompt += Write-Prompt -Object "$($pp.PromptSymbols.SegmentForwardSymbol)" -BackgroundColor $pp.Colors.LightForegroundColor -ForegroundColor $pp.Colors.DarkForegroundColor
        # Writes the Github Logo
        $prompt += Write-Prompt -Object " $($pp.PromptSymbols.GitSymbol) " -ForegroundColor $pp.Colors.DarkForegroundColor -BackgroundColor $pp.Colors.LightForegroundColor
        # Fetch Github Status
        $themeInfo = Get-VcsInfo -status ($status)
        # Writes the postfix (>) to the prompt
        $prompt += Write-Prompt -Object $pp.PromptSymbols.SegmentForwardSymbol -ForegroundColor $pp.Colors.LightForegroundColor -BackgroundColor $themeInfo.BackgroundColor
        # Writes Github status
        $prompt += Write-Prompt -Object " $($themeInfo.VcInfo) " -BackgroundColor $themeInfo.BackgroundColor -ForegroundColor $pp.Colors.DarkForegroundColor
        # Sets the final color
        $lastColor = $themeInfo.BackgroundColor
    }

    # Writes the postfix (>) to the prompt
    $prompt += Write-Prompt -Object $pp.PromptSymbols.SegmentForwardSymbol -ForegroundColor $lastColor
    $prompt += ' '
    $prompt
}

$pp = $global:ThemeSettings #local settings
# Symbols
$pp.PromptSymbols.UserSymbol = [char]::ConvertFromUtf32(0xf007)
$pp.PromptSymbols.FolderSymbol = [char]::ConvertFromUtf32(0xf07c)
$pp.PromptSymbols.UnlockedSymbol = [char]::ConvertFromUtf32(0xf13e)
$pp.PromptSymbols.LockedSymbol = [char]::ConvertFromUtf32(0xf023)
$pp.PromptSymbols.SegmentForwardSymbol = [char]::ConvertFromUtf32(0xE0B0)
$pp.PromptSymbols.GitSymbol = [char]::ConvertFromUtf32(0xf418)
# Colors
$pp.Colors.DarkForegroundColor = [ConsoleColor]::Black
$pp.Colors.LightForegroundColor = [ConsoleColor]::White
$pp.Colors.HostnameBackgroundColor = [System.ConsoleColor]::Gray
$pp.Colors.UsernameBackgroundColor = [System.ConsoleColor]::DarkGray
$pp.Colors.DirectoryBackgroundColor = [System.ConsoleColor]::Blue
$pp.Colors.DriveBackgroundColor = [System.ConsoleColor]::DarkBlue