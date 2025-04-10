#!/usr/bin/env zsh
set -euo pipefail

# Change directory
cd ${1:h}

chmod u+x ${1}

# Execute in bubblewrap
bwrap \
    --bind $PWD $PWD \
    --bind $HOME/.local/share $HOME/.local/share \
    --ro-bind /usr /usr \
    --ro-bind /bin /bin \
    --ro-bind /lib /lib \
    --ro-bind /lib64 /lib64 \
    --ro-bind /etc /etc \
    --ro-bind /var /var \
    --ro-bind /run /run \
    --ro-bind /tmp /tmp \
    --ro-bind /dev /dev \
    --ro-bind /sys /sys \
    --setenv XDG_RUNTIME_DIR $XDG_RUNTIME_DIR \
    --ro-bind $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY \
    --ro-bind $XDG_RUNTIME_DIR/pipewire-0 $XDG_RUNTIME_DIR/pipewire-0 \
    --proc /proc \
    --dev /dev \
    --dev-bind /dev/dri /dev/dri \
    --unshare-all \
    --unshare-net \
    --die-with-parent \
    ${1}
