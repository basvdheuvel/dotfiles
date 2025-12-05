if status is-interactive
    # Commands to run in interactive sessions can go here
end

source /home/vdheuvel/.config/fish/functions/bundle.fish
fish_add_path /home/vdheuvel/.local/bin
rvm default
nvm use default >/dev/null
