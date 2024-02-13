#!/usr/bin/bash

echo -e "\nShell Configurations"
sudo usermod -s /usr/bin/zsh $(whoami) &> /dev/null
sudo usermod -s /usr/bin/zsh root &> /dev/null

echo -e "\nPrezto configuration complete (plugins will be installed on the first shell run)"

try_exec_zsh() {
    >'/dev/null' 2>&1 command -v "$1" || 'return' '0'
    <'/dev/null' >'/dev/null' 2>&1 'command' "$1" '-fc' '
    [[ $ZSH_VERSION == (5.<8->*|<6->.*) ]] || return
    exe=${${(M)0:#/*}:-$commands[$0]}
    zmodload -s zsh/terminfo zsh/zselect || [[ $ZSH_PATCHLEVEL == zsh-5.8-0-g77d203f && $exe == */bin/zsh && -e ${exe:h:h}/share/zsh/5.8/scripts/relocate ]]' || 'return' '0'
    'exec' "$@" || 'return'
}
exec_zsh() {
    'try_exec_zsh' 'zsh' "$@" || 'return'
    'try_exec_zsh' '/usr/local/bin/zsh' "$@" || 'return'
    'try_exec_zsh' '/bin/zsh' "$@" || 'return'
}
'exec_zsh' '-i'
