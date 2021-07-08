#!/bin/sh

__shellname="$(basename ${SHELL})"

case "${__shellname}" in
  zsh)  __sh_config="${HOME}/.zshrc" ;;
  bash) __sh_config="${HOME}/.bashrc" ;;
  *)
    >&2 \echo "Codegem CLI is incompatible with your shell (${__shellname})"
    \exit 1
    ;;
esac

__base_repository_path="${HOME}/src/github.com/CodegemIO"

if [ -d "${__base_repository_path}/cli" ]; then
  echo "Codegem CLI repository already cloned, skipping"
else
  echo "Downloading CLI repository"
  mkdir -p "${__base_repository_path}"
  cd "${__base_repository_path}" && git clone git@github.com:CodegemIO/cli.git

  echo "Installing dependencies"
  cd cli && bundle install
fi

__required_line=". ~/src/github.com/CodegemIO/cli/cli.sh"

if grep -Fxq "${__required_line}" "${__sh_config}"
then
  echo "Codegem CLI is already installed"
else
  echo "${__required_line}" >> "${__sh_config}"
  echo "Codegem CLI installed successfully, please restart your shell"
fi

exit 0
