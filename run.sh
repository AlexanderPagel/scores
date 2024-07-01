#!/usr/bin/env bash
# ╭──────────────────────╮
# │ 🅅 version            │
# ╰──────────────────────╯
# version 0.0.0
# ╭──────────────────────╮
# │ 🛈 Info               │
# ╰──────────────────────╯
# Dotfiles runscript template
# ╭──────────────────────╮
# │ ⚙ Boilerplate        │
# ╰──────────────────────╯
declare -gr dotfiles="${DOTFILES:-"$HOME/dotfiles"}"; # TOKEN_DOTFILES_GLOBAL
# ☯ Every file prevents multi-loads itself using this global dict
declare -gA _sourced_files=( ["runscript"]="" ); # Source only once
# 🖈 If the runscript requires a specific location, set it here
#declare -gr this_location="";
source "$dotfiles/scripts/boilerplate.sh" "${BASH_SOURCE[0]}" "$@";
# ╭──────────────────────╮
# │ 🛠Configuration      │
# ╰──────────────────────╯
_run_config["versioning"]=0;
_run_config["log_loads"]=0;
#_run_config["error_frames"]=2;
# ╭──────────────────────╮
# │ 🗀 Dependencies       │
# ╰──────────────────────╯
# ✔ Ensure versions with satisfy_version
satisfy_version "$dotfiles/scripts/boilerplate.sh" "0.0.0";
# ✔ Source versioned dependencies with load_version
load_version "$dotfiles/scripts/version.sh" "0.0.0";
#load_version "$dotfiles/scripts/assert.sh";
#load_version "$dotfiles/scripts/bash_meta.sh";
#load_version "$dotfiles/scripts/cache.sh";
#load_version "$dotfiles/scripts/error_handling.sh";
load_version "$dotfiles/scripts/fileinteracts.sh" "0.0.0";
#load_version "$dotfiles/scripts/git_utils.sh";
#load_version "$dotfiles/scripts/progress_bar.sh";
#load_version "$dotfiles/scripts/setargs.sh";
#load_version "$dotfiles/scripts/termcap.sh";
load_version "$dotfiles/scripts/userinteracts.sh" "0.0.0";
load_version "$dotfiles/scripts/utils.sh" "0.0.0";
# ╭──────────────────────╮
# │ 🗺 Globals           │
# ╰──────────────────────╯
# ╭──────────────────────╮
# │ ⌨  Commands          │
# ╰──────────────────────╯

# Default command (when no arguments are given)
command_default()
{
  subcommand muse --confirm;
}

command_listen()
{
  set_args "--help" "$@";
  eval "$get_args";
  vlc mp3/* &
}

command_move_files()
{
  set_args "--name=: --help" "$@";
  eval "$get_args";

  ensure_directory mp3;
  ensure_directory pdf;
  ensure_directory mscz;

  if [[ "$name" != ":" ]]; then
    move_by_name "$name";
  else
    2>/dev/null mv -v *".mp3" mp3/ || echos "No mp3 files";
    2>/dev/null mv -v *".pdf" pdf/ || echos "No pdf files";
    2>/dev/null mv -v *".mscz" mscz/ || echos "No mscz files";
  fi
}

command_muse()
{
  set_args "--confirm --help" "$@";
  eval "$get_args";

  echou "$0 help";
  echou "$0 COMMAND --help";

  if [[ "$confirm" == "true" ]]; then
    declare choice="n";
    boolean_prompt "Run MuseScore?" choice;
    if [[ "$choice" == "n" ]]; then
      return 0;
    fi
  fi
  ./MuseScore-Studio-4.3.2.241630832-x86_64.AppImage &
  :;
}

# ╭──────────────────────╮
# │ 🖩 Utils              │
# ╰──────────────────────╯
# ╭──────────────────────╮
# │ 𝑓 Functional         │
# ╰──────────────────────╯

# Move mscz/pdf/mp3 files containing $1 into their respective directory
move_by_name()
{
  declare -a files=( *${1:-$FUNCNAME: Missing argument}* );
  echoi "$(print_array "files")";
  if [[ "${files}" == "*${1}*" ]]; then
    echoe "No files found";
    return 0;
  fi
  declare choice="n";
  boolean_prompt "Move files?" choice;
  if [[ "$choice" == "n" ]]; then return 0; fi
  declare extension="";
  for file in "${files[@]}"; do
    extentsion="${file##*.}";
    echoi ".${extentsion@Q}";
    if [[ "$extentsion" != "mscz" && "$extentsion" != "pdf" && "$extentsion" != "mp3" ]]; then
      echos "${file@Q}";
      continue;
    fi
    mv -v "$file" "${extentsion}/";
  done
}

# ╭──────────────────────╮
# │ 🖹 Help strings       │
# ╰──────────────────────╯
declare -r listen_help_string='Listen to MP3 files';
declare -r move_files_help_string='Move PDF/MP3 files
DESCRIPTION
  Moves files into the subdirectories "pdf/" and "mp3/"
OPTIONS
  --name=: Search string (exact matching substring)';
declare -r muse_help_string='Run MuseScore
OPTIONS
  --confirm: Confirm before running';
# ╭──────────────────────╮
# │ ⚙ Boilerplate        │
# ╰──────────────────────╯
# ⌂ Transition to provided command
subcommand "${@}";
# ╭──────────────────────╮
# │ 🕮  Documentation     │
# ╰──────────────────────╯
