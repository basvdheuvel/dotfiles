set -x VISUAL nvim
set -x EDITOR $VISUAL

function dotfiles
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $argv
end

alias tlmgr='/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode'
