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

For now, clone the repository and place `bin/dmux` somewhere in your `PATH`.

```bash
git clone https://github.com/daxliniere/dmux.git
sudo install -m 0755 dmux/bin/dmux /usr/local/bin/dmux
```

Then run:

```bash
dmux
```

## Requirements

- Bash
- tmux

## Automatic session names

If you choose `n` and press Enter without entering a name, dmux assigns the first free numeric session name from `100` to `999`.

For example, if `100`, `101`, and `103` already exist, the next automatically created session is `102`.

## Version

Current version: **1.3.0**

## Licence

CC0 1.0 Universal
