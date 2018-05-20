# Aliases
# alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
alias web="docker-compose run --rm web"
alias gw="gcc -Wall"
alias workspace="cd ~/workspace"
alias gpush="git push origin master"
alias c="clear"
alias reload!=". ~/.zshrc"
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias a="cd ~/workspace/src/github.com/imjching"

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
    local tmpFile="${@%/}.tar";
    tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1;

    size=$(
        stat -f"%z" "${tmpFile}" 2> /dev/null; # macOS `stat`
        stat -c"%s" "${tmpFile}" 2> /dev/null;  # GNU `stat`
    );

    local cmd="";
    if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
        # the .tar file is smaller than 50 MB and Zopfli is available; use it
        cmd="zopfli";
    else
        if hash pigz 2> /dev/null; then
            cmd="pigz";
        else
            cmd="gzip";
        fi;
    fi;

    echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`…";
    "${cmd}" -v "${tmpFile}" || return 1;
    [ -f "${tmpFile}" ] && rm "${tmpFile}";

    zippedSize=$(
        stat -f"%z" "${tmpFile}.gz" 2> /dev/null; # macOS `stat`
        stat -c"%s" "${tmpFile}.gz" 2> /dev/null; # GNU `stat`
    );

    echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully.";
}

# Determine size of a file or total size of a directory
function fs() {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh;
    else
        local arg=-sh;
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@";
    else
        du $arg .[^.]* ./*;
    fi;
}

# Create a data URL from a file
function dataurl() {
    local mimeType="$(file -b --mime-type "$1")";
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8";
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# Compare original and gzipped file size
function gz() {
    local origsize="$(wc -c < "$1")";
    local gzipsize="$(gzip -c "$1" | wc -c)";
    local ratio="$(echo "$gzipsize * 100 / $origsize" | bc -l)";
    printf "orig: %d bytes\n" "$origsize";
    printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

# Paths to export
export DOTFILES=$(pwd)
export PATH=$PATH:$DOTFILES/bin

# to fix executables in sbin
export PATH="/usr/local/sbin:$PATH"

# golang settings
export GOROOT=$HOME/.go/1.10.2
export GOPATH=$HOME/workspace
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

# pyenv settings
# eval "$(pyenv init -)"
export PATH=${HOME}/.pyenv/shims:${PATH}
export PYENV_SHELL=zsh
# command pyenv rehash 2>/dev/null

# chruby and ruby-install settings
source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
chruby 2.5.1
