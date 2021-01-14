#GREP
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

#IP
alias publicIP='curl ifconfig.io'

# VIM
alias v='vim'
alias V='vim'

#PYTHON
alias setvenv='python3 -m venv' #directory
alias setvenv2='python -m venv'

#DOCKER
denter () { docker start $1 ; docker exec -it $1 /bin/bash }
dstart () { docker start -ai $1 }

#TAR
alias untar='tar xzvf'
alias compress='tar czvf'

#7zip
alias 7pass='echo "7z a dir.7z file -p"'

#Termbin
alias termbin="nc termbin.com 9999"

#IP
alias ip="ip addr | grep -o 'inet [0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+' | cut -d' ' -f2"

#DOMAIN
dmarc () { dig txt _dmarc.$1 }

#SIZE
alias realsize='du -sh * 2>/dev/null|sort -n'
