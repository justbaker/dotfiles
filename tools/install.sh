#! /usr/bin/env sh

USER_HOME=$HOME
DOTFILES_ROOT="$USER_HOME/dotfiles"
REPO_URL="https://github.com/justbaker/dotfiles.git"
THEME="justbake"
link_dirs=(oh-my-zsh zsh vim bin config tmux)
link_rcs=(zsh vim)

main () {

  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
  if which tput >/dev/null 2>&1; then
      ncolors=$(tput colors)
  fi
  if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
  fi

  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e

  if [ ! -x `which brew` ] || [ ! -d "${USER_HOME}/.oh-my-zsh" ]; then
    echo "${RED}This setup script require USER_HOMEbrew (http://brew.sh) and oh-my-zsh(http://ohmyz.sh) to be installed${NORMAL}\n"
    exit 1
  else
    echo "${BLUE}Brew and oh-my-zsh installed. Proceeding.${NORMAL}\n"
  fi

  echo "The default install location is"

  if [ ! -d "${DOTFILES_ROOT}/zsh" ]; then
    echo "${BLUE}Cloning into ${DOTFILES_ROOT} from $REPO_URL ${NORMAL}\n"
    git clone --recursive $REPO_URL $DOTFILES_ROOT || {
      echo "${RED}Error: git clone of dotfiles repo $REPO_URL failed${NORMAL}\n"
      exit 1
    }
    echo "continute installing"
  fi

  echo "${BLUE}Installing into ${USER_HOME} from ${DOTFILES_ROOT}${NORMAL}\n"

  exit 1

  if [ ! -d "${USER_HOME}/.config" ]; then
    echo "=== Creating .config dir in ${USER_HOME}"
    mkdir "${USER_HOME}/.config"
  fi

  echo "=== Linking powerline directory"
  ln -s "#{DOTFILES_ROOT}/config/powerline", "#{USER_HOME}/.config/powerline"

  for dir in ${link_dirs[@]}; do

   if [ -L "${DOTFILES_ROOT}/${dir}" ]; then
     echo "=== Found symlink at ${DOTFILES_ROOT}/${dir}...removing"
     rm -rf "${DOTFILES_ROOT}/${dir}"
   fi

   echo "=== Linking ${USER_HOME}/${dir} to ${DOTFILES_ROOT}/${dir}"
   ln -s "${USER_HOME}/${dir} ${DOTFILES_ROOT}/${dir}"
  done

  for dir in ${link_rcs[@]}; do
    echo "=== Linking ${DOTFILES_ROOT}/${dir}/${dir}rc to ${USER_HOME}/.${dir}rc"
    ln -s "${DOTFILES_ROOT}/${dir}/${dir}rc" "${USER_HOME}/.${dir}rc"
  done

  if [ -L "${USER_HOME}/.oh-my-zsh/custom/themes" ]; then
    echo "=== Directory ${USER_HOME}/.oh-my-zsh/custom/themes exists. Skipping\n"
  else
    echo "=== Creating directory ${USER_HOME}/.oh-my-zsh/custom/themes\n"
    mkdir -p "${USER_HOME}/.oh-my-zsh/custom/themes"
  fi

  echo "=== Linking oh-my-zsh themes from ${USER_HOME}/.zsh/${THEME} to ${USER_HOME}/.oh-my-zsh/custom/themes/${THEME}"
  ln -s "${USER_HOME}/.zsh/${THEME}.zsh-THEME", "${USER_HOME}/.oh-my-zsh/custom/themes/${THEME}.zsh-THEME"

  if [ -L "${USER_HOME}/tmux/tmux.conf" ]; then
    echo "${YELLOW} ${USER_HOME}/tmux/tmux.conf already exists..skipping.${NORMAL}\n"
  else
    mkdir -p "${USER_HOME}/tmux"
    echo "=== Linking tmux config from ${DOTFILES_ROOT}/tmux/tmux.conf to ${USER_HOME}/.tmux.conf"
    ln -s "${DOTFILES_ROOT}/tmux/tmux.conf", "${USER_HOME}/.tmux.conf"
  fi

  echo "${GREEN}\n\n"
  echo "dotfiles installed!!"
  echo "Now run `source ${USER_HOME}/.zshrc`"
  echo "${NORMAL}\n\n"
  exit 0
}

main
