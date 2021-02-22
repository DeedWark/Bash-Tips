# GREP
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# IP
alias publicIP='curl ifconfig.me ; echo -e "\n"'
alias ip="ip addr | grep -o 'inet [0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+' | cut -d' ' -f2"

# VIM
alias v='vim'
alias V='vim'

# PYTHON
alias setvenv='python3 -m venv' #setvenv <name>
alias setvenv2='python -m venv'

# DOCKER
dstart () { docker start -ai $1 }
denter () { docker start $1 ; docker exec -it $1 /bin/bash }
dexec () { docker start $1 ; docker exec -it $1 $2 }

# TAR
alias untar='tar xzvf'
alias compress='tar czvf'

# 7ZIP
alias 7pass='echo "7z a dir.7z file -p"'

# TERMBIN
alias termbin="nc termbin.com 9999"
termbinc () { nc termbin.com $1 }

# IP
alias ip="ip addr | grep -o 'inet [0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+' | cut -d' ' -f2"

# DOMAIN
dmarc () { dig txt _dmarc.$1 }

# SIZE
alias realsize='du -sh * 2>/dev/null|sort -n'

# KITTERMAN
alias kitterman='docker run --rm deedwark/spftools'
