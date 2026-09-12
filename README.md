# dmux

A simple menu-driven front-end for tmux.

dmux is designed for people who want the persistence and flexibility of tmux without having to remember tmux session-management commands.

## Features

- Zero-based numbered menu of existing tmux sessions
- Attach to a session by typing its menu number
- Create a named session
- Press Enter when creating a session to get the first free three-digit session name
- Rename an existing session from a numbered menu
- Respawn an existing session from a numbered menu, recreating it with the same name
- Kill an existing session from a numbered menu
- Return to the dmux menu after detaching from a tmux session
- Selecting a session always enters it: dmux attaches when outside tmux and switches the current client when already inside tmux
- When dmux is launched inside tmux, the current session is marked with a yellow ` (current session)` suffix
- Selecting the already-current session exits dmux, the same as pressing `q`
- When switching sessions from inside tmux, dmux exits cleanly after the switch so stale menu processes do not accumulate
- Lightweight Bash implementation
- tmux is the only runtime dependency

## Example

```text
dmux 1.4.10
==========

0 - some_session
1 - another_session

n - create new
r - rename existing session
s - respawn existing session
k - kill existing session
q - quit

>
```

## Installation

### Debian/Ubuntu - root shell

```bash
apt update
apt install -y git tmux

if [ -d /root/dmux/.git ]; then
    cd /root/dmux
    git fetch origin
else
    git clone https://github.com/daxliniere/dmux.git /root/dmux
    cd /root/dmux
fi

git show origin/main:bin/dmux > /tmp/dmux-install
grep -q '^# dmux v' /tmp/dmux-install || {
    echo "Refusing installation: fetched file does not look like dmux"
    rm -f /tmp/dmux-install
    exit 1
}

install -m 0755 /tmp/dmux-install /usr/bin/dmux
rm -f /tmp/dmux-install

if [ -L /usr/local/bin/dmux ]; then
    ln -sfn /usr/bin/dmux /usr/local/bin/dmux
elif [ -f /usr/local/bin/dmux ] && grep -q '^# dmux v' /usr/local/bin/dmux 2>/dev/null; then
    rm -f /usr/local/bin/dmux
    ln -s /usr/bin/dmux /usr/local/bin/dmux
fi

hash -r 2>/dev/null || true
dmux
```

### Debian/Ubuntu - normal user with sudo

```bash
sudo apt update
sudo apt install -y git tmux

if [ -d "$HOME/dmux/.git" ]; then
    cd "$HOME/dmux"
    git fetch origin
else
    git clone https://github.com/daxliniere/dmux.git "$HOME/dmux"
    cd "$HOME/dmux"
fi

git show origin/main:bin/dmux > /tmp/dmux-install
grep -q '^# dmux v' /tmp/dmux-install || {
    echo "Refusing installation: fetched file does not look like dmux"
    rm -f /tmp/dmux-install
    exit 1
}

sudo install -m 0755 /tmp/dmux-install /usr/bin/dmux
rm -f /tmp/dmux-install

if [ -L /usr/local/bin/dmux ]; then
    sudo ln -sfn /usr/bin/dmux /usr/local/bin/dmux
elif [ -f /usr/local/bin/dmux ] && grep -q '^# dmux v' /usr/local/bin/dmux 2>/dev/null; then
    sudo rm -f /usr/local/bin/dmux
    sudo ln -s /usr/bin/dmux /usr/local/bin/dmux
fi

hash -r 2>/dev/null || true
dmux
```

These install commands only write dmux itself to `/usr/bin/dmux`, and only replace `/usr/local/bin/dmux` when that path is already a symlink or can be positively identified as an older dmux script.

## Updating a single installation

From a root shell where the deployment clone is `/root/dmux`:

```bash
cd /root/dmux || exit 1
git fetch origin

git show origin/main:bin/dmux > /tmp/dmux-update
grep -q '^# dmux v' /tmp/dmux-update || {
    echo "Refusing update: fetched file does not look like dmux"
    rm -f /tmp/dmux-update
    exit 1
}

install -m 0755 /tmp/dmux-update /usr/bin/dmux
rm -f /tmp/dmux-update

if [ -L /usr/local/bin/dmux ]; then
    ln -sfn /usr/bin/dmux /usr/local/bin/dmux
elif [ -f /usr/local/bin/dmux ] && grep -q '^# dmux v' /usr/local/bin/dmux 2>/dev/null; then
    rm -f /usr/local/bin/dmux
    ln -s /usr/bin/dmux /usr/local/bin/dmux
fi

hash -r 2>/dev/null || true
grep '^# dmux v' /usr/bin/dmux
```

This does not run `git reset --hard` and does not modify tracked files in the local clone.

## Updating dmux across Proxmox LXCs

Run this on the Proxmox host. It updates only running LXCs that already contain a dmux checkout at `/root/dmux`:

```bash
for CTID in $(pct list | awk 'NR>1 && $2=="running" {print $1}'); do
    echo "Updating dmux in CT $CTID..."

    pct exec "$CTID" -- bash -lc '
        REPO=/root/dmux
        TMP=/tmp/dmux-update-$$

        if [ ! -d "$REPO/.git" ]; then
            echo "Skipping: /root/dmux is not a dmux git checkout"
            exit 0
        fi

        cd "$REPO" || exit 1

        if ! git fetch origin; then
            echo "Failed: could not fetch dmux"
            exit 1
        fi

        if ! git show origin/main:bin/dmux > "$TMP"; then
            echo "Failed: could not read dmux from origin/main"
            rm -f "$TMP"
            exit 1
        fi

        if ! grep -q "^# dmux v" "$TMP"; then
            echo "Refusing update: fetched file does not look like dmux"
            rm -f "$TMP"
            exit 1
        fi

        install -m 0755 "$TMP" /usr/bin/dmux
        rm -f "$TMP"

        if [ -L /usr/local/bin/dmux ]; then
            ln -sfn /usr/bin/dmux /usr/local/bin/dmux
        elif [ -f /usr/local/bin/dmux ] && grep -q "^# dmux v" /usr/local/bin/dmux 2>/dev/null; then
            rm -f /usr/local/bin/dmux
            ln -s /usr/bin/dmux /usr/local/bin/dmux
        fi

        printf "Installed: "
        grep "^# dmux v" /usr/bin/dmux | sed "s/^# //"
    '

    echo
done
```

The fleet updater deliberately does **not** use `git reset --hard`. It does not alter the container's working tree, package configuration, services, shell profiles, or unrelated files. It writes only the dmux executable and, where already identifiable as dmux, its compatibility path at `/usr/local/bin/dmux`.

## Requirements

- Bash
- tmux (will be installed using the above installation command)

## Automatic session names

If you choose `n` and press Enter without entering a name, dmux assigns the first free numeric session name from `100` to `999`.

For example, if `100`, `101`, and `103` already exist, the next automatically created session is `102`.

## Version

Current version: **1.4.10**

## Licence

CC0 1.0 Universal


## Debian/Ubuntu packaging

The repository now includes standard Debian packaging metadata under `debian/`.

The package declares `tmux` as a runtime dependency, so installing the generated `.deb` with APT automatically installs tmux when required.

To build a Debian package locally:

```bash
apt update
apt install -y build-essential debhelper devscripts
git clone https://github.com/daxliniere/dmux.git
cd dmux
dpkg-buildpackage -us -uc -b
```

The resulting `.deb` is created in the parent directory.

For Launchpad/PPA uploads, build a signed source package with:

```bash
dpkg-buildpackage -S -sa
```


## Updating dmux across Proxmox LXCs

If dmux is already installed in multiple running Proxmox LXCs and each container has the repository cloned at `/root/dmux`, run this on the Proxmox host:

```bash
for CTID in $(pct list | awk 'NR>1 && $2=="running" {print $1}'); do
    echo "Updating dmux in CT $CTID..."

    pct exec "$CTID" -- bash -lc '
        set -e

        if [ ! -d /root/dmux/.git ]; then
            echo "dmux repo not found in /root/dmux"
            exit 0
        fi

        cd /root/dmux
        git fetch origin
        git reset --hard origin/main

        rm -f /usr/bin/dmux
        rm -f /usr/local/bin/dmux

        install -m 0755 bin/dmux /usr/bin/dmux
        ln -s /usr/bin/dmux /usr/local/bin/dmux

        hash -r 2>/dev/null || true

        printf "Installed: "
        grep "^# dmux v" /usr/bin/dmux | sed "s/^# //"

        echo "Updated successfully"
    '

    echo
done
```

This deliberately resets the deployment clone to `origin/main` and discards local changes inside `/root/dmux`. It also removes stale copies and makes `/usr/local/bin/dmux` a symlink to the canonical `/usr/bin/dmux`, preventing different shells from running different versions because of PATH ordering.
