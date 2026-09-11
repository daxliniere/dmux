# Changelog

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
