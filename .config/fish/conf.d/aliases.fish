function libreowolf
command flatpak run io.gitlab.librewolf-community $argv
end
function keepassxc
command flatpak run org.keepassxc.KeePassXC $argv
end
function spotify
command flatpak run com.spotify.Client
end

function hyprconf
command nvim /home/pryniki/.config/hypr/ $argv
end

function networkconf
command sudo nvim /etc/systemd/network/ && sudo systemctl restart systemd-networkd && sudo systemctl restart systemd-resolved $argv
end

function ls
command ls --color=auto $argv
end
function grep
command grep --color=auto $argv
end
