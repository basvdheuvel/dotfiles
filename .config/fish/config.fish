set -x VISUAL nvim
set -x EDITOR $VISUAL

alias tlmgr='/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode'

alias urldecode='python -c "import sys, urllib.parse as ul; [sys.stdout.write(ul.unquote_plus(l)) for l in sys.stdin]"'

if status is-interactive
    # Commands to run in interactive sessions can go here
end

source /home/bas/.config/fish/functions/bundle.fish
fish_add_path /home/bas/.local/bin
set -U FZF_LEGACY_KEYBINDINGS 0
rvm default
nvm use default >/dev/null
