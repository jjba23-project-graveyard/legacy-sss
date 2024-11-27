# SSS - Supreme Sexp System

# Copyright (C) 2024 Josep Bigorra

# Author: Josep Bigorra <jjbigorra@gmail.com>
# Maintainer: Josep Bigorra <jjbigorra@gmail.com>
# URL: https://github.com/jjba23/sss

# sss is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# sss is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with sss.  If not, see <https://www.gnu.org/licenses/>.

# Commentary:

# TODO

# Code:

# bash colors
blk='\[\033[01;30m\]'   # Black
red='\[\033[01;31m\]'   # Red
grn='\[\033[01;32m\]'   # Green
ylw='\[\033[01;33m\]'   # Yellow
blu='\[\033[01;34m\]'   # Blue
pur='\[\033[01;35m\]'   # Purple
cyn='\[\033[01;36m\]'   # Cyan
wht='\[\033[01;37m\]'   # White
clr='\[\033[00m\]'      # Reset


# set size and add date and time to `history` command
export HISTTIMEFORMAT="%F %T  | "
export HISTSIZE=200000
export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=200000

# set history to append
shopt -s histappend

alias ..='cd ..;pwd'
alias ...='cd ../..;pwd'
alias ....='cd ../../..;pwd'

# Press c to clear the terminal screen.
alias c='clear'

# Press h to view the bash history.
alias h='history'

# Display the directory structure better.
alias tree='tree --dirsfirst -F'

# Make a directory and all parent directories with verbosity.
alias mkdir='mkdir -p -v'

alias ll="ls -lAh --group-directories-first"
alias l="ls -lAh --group-directories-first"
alias e="emacsclient -t"
alias fr="cd ~/Ontwikkeling/Persoonlijk/sss && make fr"
alias sr="cd ~/Ontwikkeling/Persoonlijk/sss && make sr"
alias jr="cd ~/Ontwikkeling/Persoonlijk/sss && make jr"

alias scala-dev="nix develop /home/joe/Ontwikkeling/Persoonlijk/sss/resources/flakes/scala-dev/"
alias haskell-dev="nix develop /home/joe/Ontwikkeling/Persoonlijk/sss/resources/flakes/haskell-dev/"

function glog() {
    sudo gzip -d "$1.gz" && cat "$1"
}

# Sway screen configurations and aliases
function work_macbook_output() {
    swaymsg -- output Virtual-1 mode --custom 3840x2400 scale 2
}

function work_macbook_present_output() {
    swaymsg -- output Virtual-1 mode --custom 3840x2400 scale 3
}

alias owm='work_macbook_output'
alias owmp='work_macbook_present_output'

function find_largest_files() {
    du -h -x -s -- * | sort -r -h | head -20;
}

# Grep (search) through your history for previous run commands:

function hg() {
    history | grep "$1";
}

eval "$(fzf --bash)"

# Load Nix profile 
source /run/current-system/profile/etc/profile.d/nix.sh

# Set the prompt.
export PS1=${grn}"\\u@\\h \\w${GUIX_ENVIRONMENT:+ [env]} λ"${clr}"  "
