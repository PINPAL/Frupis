# PinShell

**Windows Powershell Theme**

Completely customized color and prompt theme for Windows Powershell

## Prerequisites

1. Follow the installation for [oh-my-posh v2](https://github.com/JanDeDobbeleer/oh-my-posh)
2. Download [ColorTool](https://github.com/microsoft/terminal/tree/main/src/tools/ColorTool) from Microsoft
3. Ensure you are using a Powerline font patched with Nerd Font. I personally use [CascadiaCode](https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/CascadiaCode/complete/Caskaydia%20Cove%20Regular%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf) but there is a large selection in [this repo](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts).
4. Clone this repo to a temporary folder.

## Installation

After you have completed the prerequisites, the first step is to configure your `$profile`. This file is equivilent to the `.bashrc` found in a UNIX system.
The directory of which can be found by entering the following into a powershell window:

```powershell
PS > $profile
```

You will need to add the following lines to the end of the file:

```powershell
# Import Modules
Import-Module posh-git
Import-Module oh-my-posh

# Setup Theme
Set-Theme PINPAL

# Setup Prompt colors
Set-PSReadlineOption -Color @{
    "Command"   = [ConsoleColor]::White
    "Parameter" = [ConsoleColor]::Gray
    "Operator"  = [ConsoleColor]::Magenta
    "Variable"  = [ConsoleColor]::Green
    "String"    = [ConsoleColor]::Yellow
    "Number"    = [ConsoleColor]::Blue
    "Type"      = [ConsoleColor]::Cyan
    "Comment"   = [ConsoleColor]::DarkCyan
}
```

Once you have configured your profile you will need to install the theme colors.
To do this unzip the ColorTool fill and navigate to the folder that contains the exectuable and the `schemes` folder.

You can then copy over the contents of the `schemes` folder from this repo into the one from ColorTool.

Next open up powershell and navigate to the ColorTool directory. Execute the following command to install the theme.

```powershell
PS > ./ColorTool.exe -b PINPAL.itermcolors
```

You should now see that your terminal is nicely coloured.

The last step is to install the prompt theme.
You can find the directory that the theme needs to be installed to by entering the following into powershell:

```powershell
PS > $ThemeSettings
```

Navigate to the `CurrentThemeLocation` folder and copy over the `PINPAL.psm1` file from this repo to your `CurrentThemeLocation` folder.

The final step is to enable the theme which can be done by entering the following into powershell:

```powershell
PS > Set-Theme PINPAL
```

## Preview

![Preview Image](./preview.png)
