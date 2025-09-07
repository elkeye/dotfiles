if status is-interactive
end

set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket

zoxide init fish | source

export "MICRO_TRUECOLOR=1"
