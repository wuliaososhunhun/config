# alias
alias vi='vim'
alias sshXXX='read SERVER_INDEX ; ssh XXX@XXX0$SERVER_INDEX'

# functions
gitcheck() { git log --pretty=oneline --abbrev-commit $1..$2 | grep -E "^[A-Za-z0-9]{7} +([a-zA-Z]+-[0-9]+)[ :].*"  | sed -E "s/^[A-Za-z0-9]{7} +([a-zA-Z]+-[0-9]+)[ :].*/\1/g" | sort | uniq -u ; }

# source
[[ -s ~/.git-completion.bash ]] && source ~/.git-completion.bash
[[ -s ~/.git-prompt.sh ]] && source ~/.git-prompt.sh
[[ -s ~/.bashrc ]] && source ~/.bashrc

# path

