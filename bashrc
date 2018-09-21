# .bashrc

function conditional_source () {
    if [[ -a $@ ]]; then
	source $@
    fi	    
}

conditional_source $HOME/.bashpy

export PS1="\h:\W -> "

export PAGER=less
export LESS="-MXFR"
export EDITOR=vi
export VISUAL=vi

alias bak='rm *~ .*~ \#* >& /dev/null'
alias df='df -H'
alias j='jobs -l'
alias ls='ls -F'
alias rm='rm -f'
