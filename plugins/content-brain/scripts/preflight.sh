#!/usr/bin/env bash
# preflight.sh — check (and optionally install) the tools Content Brain needs.
# Usage:
#   preflight.sh            # check only, print status, install nothing
#   preflight.sh --install  # install anything missing (asks Homebrew to do the work)
#
# Safe to re-run. Prints one STATUS line per tool so the caller can parse it.
set -u

INSTALL=0
[ "${1:-}" = "--install" ] && INSTALL=1

say()  { printf '%s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

# STATUS <tool> <ok|missing|installed|failed> <detail>
STATUS() { printf 'STATUS\t%s\t%s\t%s\n' "$1" "$2" "${3:-}"; }

say "== Content Brain preflight =="
say "Platform: $(uname -s) $(uname -m)"
say ""

# --- Homebrew ---------------------------------------------------------------
if have brew; then
  STATUS brew ok "$(brew --version 2>/dev/null | head -1)"
else
  if [ "$INSTALL" = "1" ]; then
    say "Installing Homebrew (you may be asked for your Mac password)..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
    # Make brew available on Apple Silicon and Intel for the rest of this run.
    if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
    if [ -x /usr/local/bin/brew ]; then eval "$(/usr/local/bin/brew shellenv)"; fi
    if have brew; then STATUS brew installed; else STATUS brew failed "install Homebrew manually from https://brew.sh"; fi
  else
    STATUS brew missing "needed to install the other tools"
  fi
fi

# brew_install <formula> [--cask]
brew_install() {
  formula="$1"; shift
  if [ "$INSTALL" = "1" ] && have brew; then
    say "Installing $formula ..."
    brew install "$@" "$formula" </dev/null && return 0 || return 1
  fi
  return 2
}

# --- ffmpeg -----------------------------------------------------------------
if have ffmpeg; then
  STATUS ffmpeg ok
else
  if brew_install ffmpeg; then STATUS ffmpeg installed; else STATUS ffmpeg missing "brew install ffmpeg"; fi
fi

# --- yt-dlp -----------------------------------------------------------------
if have yt-dlp; then
  STATUS yt-dlp ok "$(yt-dlp --version 2>/dev/null)"
else
  if brew_install yt-dlp; then STATUS yt-dlp installed; else STATUS yt-dlp missing "brew install yt-dlp"; fi
fi

# --- python3 (needed by Whisper) --------------------------------------------
if have python3; then
  STATUS python3 ok "$(python3 --version 2>&1)"
else
  if brew_install python; then STATUS python3 installed; else STATUS python3 missing "brew install python"; fi
fi

# --- Whisper (openai-whisper CLI) -------------------------------------------
# Transcription is the heaviest install (pulls PyTorch). Only needed when a
# piece of audio/video has no captions of its own.
if have whisper; then
  STATUS whisper ok
else
  if [ "$INSTALL" = "1" ]; then
    if ! have pipx && have brew; then say "Installing pipx ..."; brew install pipx </dev/null; pipx ensurepath >/dev/null 2>&1 || true; fi
    if have pipx; then
      say "Installing Whisper (this is a large download, several minutes)..."
      pipx install openai-whisper </dev/null && STATUS whisper installed || STATUS whisper failed "pipx install openai-whisper"
    else
      python3 -m pip install --user -U openai-whisper </dev/null && STATUS whisper installed || STATUS whisper failed "pip install openai-whisper"
    fi
  else
    STATUS whisper missing "optional until transcription; installs PyTorch"
  fi
fi

# --- Obsidian (app, not CLI) ------------------------------------------------
if [ -d "/Applications/Obsidian.app" ] || [ -d "$HOME/Applications/Obsidian.app" ]; then
  STATUS obsidian ok
else
  if brew_install --cask obsidian; then STATUS obsidian installed; else STATUS obsidian missing "download from https://obsidian.md or: brew install --cask obsidian"; fi
fi

say ""
say "== preflight done =="
