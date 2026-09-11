# dmux

A simple menu-driven front-end for tmux.

dmux is designed for people who want the persistence and flexibility of tmux without having to remember tmux session-management commands.

## Features

- Zero-based numbered menu of existing tmux sessions
- Attach to a session by typing its menu number
- Create a named session
- Press Enter when creating a session to get the first free three-digit session name
- Rename an existing session from a numbered menu
- Kill an existing session from a numbered menu
- Return to the dmux menu after detaching from a tmux session
- Selecting a session always enters it: dmux attaches when outside tmux and switches the current client when already inside tmux
- When switching sessions from inside tmux, dmux exits cleanly after the switch so stale menu processes do not accumulate
- Lightweight Bash implementation
- tmux is the only runtime dependency

## Example

```text
dmux
====

0 - some_session
1 - another_session

n - create new
r - rename existing session
k - kill existing session
q - quit

>
```

## Installation

On Debian or Ubuntu systems, the installer checks for `git` and `tmux`, installs either dependency automatically if it is missing, and installs `dmux` into `/usr/bin`. If `apt-get update` fails because of an unrelated broken third-party repository, the installer will warn and still attempt dependency installation using the existing package lists.

```bash
apt update
apt install -y git tmux

git clone https://github.com/daxliniere/dmux.git
cd dmux
chmod +x install.sh
./install.sh

hash -r
dmux
```

## To update

```
cd ~/dmux
git pull
install -m 0755 bin/dmux /usr/bin/dmux
hash -r
dmux
```

## Requirements

- Bash
- tmux (will be installed using the above installation command)

## Automatic session names

If you choose `n` and press Enter without entering a name, dmux assigns the first free numeric session name from `100` to `999`.

For example, if `100`, `101`, and `103` already exist, the next automatically created session is `102`.

## Version

Current version: **1.4.0**

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
