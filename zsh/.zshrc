printf '\33c\e[3J'

export ZSH="$HOME/.oh-my-zsh"
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
export SHELL="zsh"

DISABLE_AUTO_TITLE="true"

# ZSH_THEME="frontcube"
ZSH_THEME="theunraveler"
plugins=(colored-man-pages zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vi'
else
    export EDITOR='hx'
fi

# User configuration

# general aliases
alias e='exit'
alias f='open . && exit'
alias rm='rm -r'
alias pwd='pwd && pwd | pbcopy'
alias mkdir='mkdir -p'
alias css='rm -f ~/Screenshots/* && echo "screenshots cleared"'
alias bup='brew update && brew autoremove && brew cleanup && brew upgrade'
alias npmg='npm list -g --depth 0'
alias yup='echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" &&
echo && echo "paste into:" &&
echo "/private/etc/sudoers.d/yabai"'

# directory aliases
alias ls='ls -AG'
alias ..='cd ..'
alias app='builtin cd /Applications/ && ls'
alias doc='builtin cd ~/Documents/ && ls'
alias dow='builtin cd ~/Downloads/ && ls'
alias des='builtin cd ~/Desktop/ && ls'
alias ss='builtin cd ~/Screenshots/ && ls'
alias hub='builtin cd ~/Github/ && ls'
alias lab='builtin cd ~/Gitlab/ && ls'
alias kd='builtin cd ~/Gitlab/auto-agent-fengsm/ && ls'
alias bs='builtin cd ~/Github/boss-system/ && ls'
alias bc='builtin cd ~/Github/boss-code/ && ls'
alias euler='builtin cd ~/euler/ && ls'
alias dp='builtin cd ~/atcoder-dp/ && ls'

# app aliases
alias rg='ranger'

# config aliases
alias zrc="hx ~/.zshrc"
alias rs="clear && source ~/.zshrc"
alias src="hx ~/.config/skhd/skhdrc"
alias srs="skhd --restart-service"
alias yrc="hx ~/.config/yabai/yabairc"
alias yrs="yabai --restart-service"
alias cf="builtin cd ~/.config && ls"
alias ub='builtin cd ~/.config/ubersicht && ls'
alias ch="rm -f ~/.zsh_history && clear"

# enter alias
accept-line() {
    if [[ -z $BUFFER ]]; then
        zle -I
        # command to run when enter pressed
        clear && ls
    else
        zle ".$WIDGET"
    fi
}
zle -N accept-line

# cd function
cd() {
    # if no DIR given, go home
    if [[ "$@" == "" ]]; then
        builtin cd $HOME && ls
    # if the path only contains . and /
    elif [[ "$@" =~ ^[./-]+$ ]]; then
        builtin cd "$@" && ls
    # if the path contains a /
    elif [[ "$@" == *"/"* ]]; then
        builtin cd "$@" && ls
    else
        # find exact match
        EXACT=$(find . -maxdepth 1 -type d -iname "$@" -print -quit)
        if [[ $EXACT != "" ]]; then
            builtin cd "${EXACT}" && ls
        else
            # find all dirs that contain string
            DIRS=$(find . -maxdepth 1 -type d -iname "*$@*" -print -quit)
            if [[ $DIRS == "" ]]; then
                echo "ERROR: no match found" 
            else
                # cd to first match
                DIR=${DIRS%%*"\n"}
                builtin cd "${DIR}" && ls
            fi
        fi
    fi
}

# git function
g() {
    if [[ "$@" == "" ]]; then
        git status
    elif [[ "$1" == "up" ]]; then
        shift
        git add --all
        git commit -a -m "$@"
        git push
    elif [[ "$1" == "commit" ]]; then
        shift
        git commit -m "$@"
    elif [[ "$1" == "clone" ]]; then
        shift
        git clone "$1" && builtin cd "$(basename "$1" .git)" #cd into cloned directory
    elif [[ "$@" == "ignore" ]]; then
        git rm -r --cached .
        git add .
        git commit -m "fix: .gitignore"
        git push
    elif [[ "$@" == "diff" ]]; then
        git diff --name-status | head --lines=29
    elif [[ "$@" == "branch" ]]; then
        git branch -vv | head --lines=29
    elif [[ "$@" == "log" ]]; then
        git log | head --lines=29
    elif [[ "$@" == "stash list" ]]; then
        git stash list | head --lines=29
    else
        git "$@"
    fi
}

alias gup='g up'

# conda function
c() {
    if [[ "$@" == "" ]]; then
        clear
    elif [[ "$1" == "a" ]]; then
        shift 
        conda activate "$@"
    elif [[ "$@" == "d" ]]; then
        conda deactivate
    else
        conda "$@"
    fi
}

alias cab='conda activate base'
alias cak='conda activate knowdee'
alias caf='conda activate firebase'

# python function
p() {
    if [[ "$@" == "" ]]; then
        echo "python: no file given"
    else
        python "$@"
    fi
}

# code functions
k() {
    if [[ "$@" == "" ]]; then
        code . && exit
    else
        code "$@"
    fi
}

h() {
    if [[ "$@" == "" ]]; then
        hx .    
    else
        hx "$@"
    fi
}

# image function
img() {
    magick "$1" "$2"
    rm "$1"
}

# search notes
n() {
    if [[ "$@" == "" ]]; then
        ls ~/Documents/Notes/
    elif [[ "$@" == "go" ]]; then
        cd ~/Documents/Notes/
    elif [[ "$1" == "h" ]]; then
        shift
        IFS=$'\n'
        INPUT="$@"
        FILES=$(find ~/Documents/Notes/ -type f -iname "*$INPUT*" -print)
        if [[ $FILES == "" ]]; then
            echo "no notes found for '$INPUT'"
        else
            for FILE in $FILES
            do
                hx $FILE
            done
        fi
        unset IFS
    elif [[ "$1" == "n" ]]; then
        shift
        INPUT="$@"
        FILE=~/Documents/Notes/"$INPUT".txt
        touch "$FILE"
        hx "$FILE"
    elif [[ "$1" == "rm" ]]; then
        shift
        INPUT="$@"
        FILE=~/Documents/Notes/"$INPUT".txt
        rm -f "$FILE"
    else
        IFS=$'\n'
        INPUT="$@"
        FILES=$(find ~/Documents/Notes -type f -iname "*$INPUT*" -print)
        if [[ $FILES == "" ]]; then
            echo "no notes found for '$INPUT'"
        else
            for FILE in $FILES
            do
                NAME=${FILE##*/}
                NAME=${NAME%".txt"}
                echo -e '\033[1;33m=='$NAME'==\033[0m'
                cat ~/Documents/Notes/"$NAME".txt
                echo ''
            done
        fi
        unset IFS
    fi
}

# go to mac-setup directory
alias mac='cd ~/Github/mac-setup/'

# copy configs to mac-setup
maccp() {
    cp -r ~/.config/helix/* ~/Github/mac-setup/config/helix/
    echo "helix config copied"
    cp -r ~/.config/kitty/* ~/Github/mac-setup/config/kitty/
    echo "kitty config copied"
    cp -r ~/.config/linearmouse/* ~/Github/mac-setup/config/linearmouse/
    echo "linearmouse config copied"
    cp -r ~/.config/ranger/* ~/Github/mac-setup/config/ranger/
    echo "ranger config copied"
    cp -r ~/.config/skhd/* ~/Github/mac-setup/config/skhd/
    echo "skhd config copied"
    cp -r ~/.config/yabai/* ~/Github/mac-setup/config/yabai/
    echo "yabai config copied"

    cp ~/.gitconfig ~/Github/mac-setup/git/
    cp ~/.gitconfig-github ~/Github/mac-setup/git/
    cp ~/.gitconfig-gitlab ~/Github/mac-setup/git/
    cp ~/.gitignore ~/Github/mac-setup/git/
    echo "git config copied"

    cp ~/.zshrc ~/Github/mac-setup/zsh/
    echo "zsh config copied"

    echo ""
    echo "all configs copied to mac-setup!"
}

# copy configs to mac-setup and push to github
macup() {
    mac
    maccp
    git add --all
    git commit -a -m "$@"
    git push
}

. "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
