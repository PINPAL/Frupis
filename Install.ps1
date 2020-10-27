# Function to write progress indicator bar
function Write-Progress($progress,[String]$step,[String]$stepDetail) {
    Write-Host (Add-Spaces -text "$progress%" -length 5) -nonewline  -ForegroundColor Black -BackgroundColor White
    Write-Host " Frupis " -nonewline  -ForegroundColor White -BackgroundColor Gray
    Write-Host (Add-Spaces -text "$step" -length 30) -nonewline  -ForegroundColor White -BackgroundColor DarkGray
    Write-Host (Add-Spaces -text "$stepDetail" -length 20) -ForegroundColor Black -BackgroundColor Blue
}

# Function to add extra spaces to the end of a string to make it to the provided length
function Add-Spaces([String]$text, $length) {
    $returnText = " $text"
    if ($text.length -lt $length) {
        For ($i=0; $i -lt ($length - $text.length); $i++) {
            $returnText = "$returnText "
        }
    }
    return $returnText
}

# Begin Installation
Write-Host "`n" -nonewline
Write-Progress -progress 0 -step "Initialising Installation" -stepDetail "Setting Up"
$InstallPath = "~/Frupis"
if (!(Test-Path -Path $InstallPath )) {
    new-item -path ~/. -name Frupis -itemtype directory > $null
}
Write-Progress -progress 10 -step "Checking Dependencies" -stepDetail "PSReadLine"
if (!(Get-InstalledModule -Name PSReadLine -MinimumVersion 2.0.0)) {
    Write-Progress -progress 15 -step "Install Dependencies" -stepDetail "PSReadLine"
    Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
}
Write-Progress -progress 20 -step "Checking Dependencies" -stepDetail "Posh Git"
if (!(Get-Module posh-git)) {
    Write-Progress -progress 25 -step "Installing Dependencies" -stepDetail "Posh Git"
    Install-Module posh-git -Scope CurrentUser
}
Write-Progress -progress 30 -step "Checking Dependencies" -stepDetail "Oh My Posh"
if (!(Get-Module oh-my-posh)) {
    Write-Progress -progress 35 -step "Installing Dependencies" -stepDetail "Oh My Posh"
    Install-Module oh-my-posh -Scope CurrentUser
}
Write-Progress -progress 40 -step "Checking Dependencies" -stepDetail "ColorTool"
if (!(Test-Path -Path $InstallPath/ColorTool )) {
    Write-Progress -progress 45 -step "Installing Dependencies" -stepDetail "ColorTool"
    $colorToolURL = "https://github.com/microsoft/terminal/releases/download/1904.29002/ColorTool.zip"
    Invoke-WebRequest -Uri $colorToolURL -OutFile $installPath/ColorTool.zip
    Expand-Archive -Path $installPath/ColorTool.zip -DestinationPath $installPath/ColorTool
}
Write-Progress -progress 50 -step "Checking Configuration" -stepDetail "PS Profile"
if (!(Test-Path -Path $profile )) {
    New-Item -Type File -Path $profile -Force
}
Write-Progress -progress 55 -step "Modifying Configuration" -stepDetail "PS Profile"
if (Test-Path -Path $profile ) {
    # FIXME: Really really terrible implementation, fix asap
    # Remove Old Frupis from Profile
    Set-Content -Path $profile -Value (get-content -Path $profile | Select-String -Pattern 'Required for Frupis' -NotMatch)
    # Append New Frupis to Profile
    Get-Content "./src/profile.ps1" | ac $profile
    # end FIXME:
}
Write-Progress -progress 70 -step "Installing Theme" -stepDetail "Color Theme"
Copy-Item -Path "./src/schemes/Frupis.itermcolors" -Destination "$installPath/ColorTool/schemes/Frupis.itermcolors"
&"$installPath/ColorTool/ColorTool.exe" -b -q Frupis.itermcolors *>$null
Write-Progress -progress 90 -step "Installing Theme" -stepDetail "Prompt Style"
if (!(Test-Path -Path $ThemeSettings.MyThemesLocation )) {
    new-item -path $ThemeSettings.MyThemesLocation -itemtype directory > $null
}
Copy-Item -Path "./src/PostThemes/Frupis.psm1" -Destination $ThemeSettings.MyThemesLocation
Write-Progress -progress 100 -step "Finalizing Installation" -stepDetail "Clean Up"
Remove-Item $InstallPath -Recurse