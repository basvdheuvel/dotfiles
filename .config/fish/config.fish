set -x VISUAL nvim
set -x EDITOR $VISUAL

alias tlmgr='/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode'

alias urldecode='python -c "import sys, urllib.parse as ul; [sys.stdout.write(ul.unquote_plus(l)) for l in sys.stdin]"'
