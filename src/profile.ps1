# Required for Frupis (DO-NOT-MODIFY)
Import-Module posh-git # Required for Frupis
Import-Module oh-my-posh # Required for Frupis
Set-Theme PINPAL # Required for Frupis
Set-PSReadlineOption -Color @{ # Required for Frupis
    "Command"   = [ConsoleColor]::White # Required for Frupis
    "Parameter" = [ConsoleColor]::Gray # Required for Frupis
    "Operator"  = [ConsoleColor]::Magenta # Required for Frupis
    "Variable"  = [ConsoleColor]::Green # Required for Frupis
    "String"    = [ConsoleColor]::Yellow # Required for Frupis
    "Number"    = [ConsoleColor]::Blue # Required for Frupis
    "Type"      = [ConsoleColor]::Cyan # Required for Frupis
    "Comment"   = [ConsoleColor]::DarkCyan # Required for Frupis
} # Required for Frupis