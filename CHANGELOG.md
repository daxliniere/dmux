# Changelog

## 1.4.3 - 2026-09-11

### Added

- Top-level menu now marks the current tmux session with `[current]`

### Changed

- Selecting the session that the user is already inside now exits dmux immediately, the same as pressing `q`
- No tmux attach or switch operation is attempted for the already-current session


## 1.4.2 - 2026-09-11

### Fixed

- Marked the dmux executable as executable in the Git repository
- Marked the installer as executable in the Git repository
- Ensures Debian package builds preserve a runnable /usr/bin/dmux


## 1.4.1 - 2026-09-11

### Fixed

- Corrected Debian native package versioning so source packages build cleanly
- Debian package version now matches the native source format


## 1.4.0 - 2026-09-11

### Added

- Standard Debian package metadata under `debian/`
- Runtime dependency on `tmux`
- Debian package build support with debhelper
- Launchpad/PPA-ready source package structure
- Local Debian build instructions in the README


## 1.3.6 - 2026-09-11

### Fixed

- A failed `apt-get update` no longer immediately aborts dependency installation
- Installer now warns about broken unrelated APT repositories and still attempts to install required dependencies from existing package lists
- Dependency installation failures now produce a clearer error explaining that APT repository configuration must be repaired


## 1.3.5 - 2026-09-11

### Fixed

- dmux now exits immediately after a successful `switch-client` operation
- Prevents old dmux menu processes remaining underneath newer invocations
- Fixes the apparent need to press `q` twice to exit after switching sessions from inside tmux
- New-session switching from inside tmux now follows the same clean-exit behavior


## 1.3.4 - 2026-09-11

### Changed

- Installer now installs `dmux` to `/usr/bin/dmux`
- Removed reliance on `/usr/local/bin` being present in the user's PATH
- This allows dmux to work immediately in existing tmux panes and other shells with a standard system PATH


## 1.3.3 - 2026-09-11

### Added

- Installer script with dependency checks
- Automatic installation of `git` and `tmux` on Debian/Ubuntu systems when missing
- Verification that `dmux` is available after installation
- Helpful PATH warning when `/usr/local/bin` is not available


## 1.3.2 - 2026-09-11

### Fixed

- Added explicit detection for whether dmux is running inside a live tmux client
- Selecting a numbered session now always enters that session
- Outside tmux, dmux uses `attach-session`
- Inside tmux, dmux uses `switch-client`, which is the tmux-safe equivalent in the same terminal
- New-session handling now follows the same inside/outside tmux logic

## 1.3.1 - 2026-09-11

### Fixed

- Selecting a session now uses `tmux switch-client` when dmux is already running inside tmux
- Session attach/switch failures are now shown instead of immediately disappearing when the menu redraws
- Creating a new session from inside tmux now creates it detached and switches to it cleanly

## 1.3.0 - 2026-09-11

### Changed

- Session menu numbering now starts at `0` instead of `1`
- Top-level, rename, and kill menus all use zero-based session numbers

## 1.2.0 - 2026-09-11

### Added

- Top-level `r` option for renaming sessions
- Numbered rename-session menu matching the kill-session menu
- Duplicate-name protection when renaming

## 1.1.0 - 2026-09-11

Initial public project version.

### Added

- Numbered session menu
- Attach by menu number
- Create named sessions
- Automatic three-digit session naming
- Kill-session menu
- Back and quit controls
- tmux dependency check
