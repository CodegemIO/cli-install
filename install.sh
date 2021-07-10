#!/bin/sh

__shellname="$(basename ${SHELL})"

if ! command -v brew &> /dev/null
then
  echo "installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "homebrew is already installed"
fi

case "${__shellname}" in
  zsh)  __sh_config="${HOME}/.zshrc" ;;
  bash) __sh_config="${HOME}/.bashrc" ;;
  *)
    >&2 \echo "codegem cli is incompatible with your shell (${__shellname})"
    \exit 1
    ;;
esac

__base_repository_path="${HOME}/src/github.com/CodegemIO"

if [ -d "${__base_repository_path}/cli" ]; then
  echo "codegem cli repository already cloned, skipping"
else
  echo "cloning cli repository"
  mkdir -p "${__base_repository_path}"
  cd "${__base_repository_path}" && git clone git@github.com:CodegemIO/cli.git

  echo "installing cli dependencies"
  cd cli && bundle install
fi

if ! [ -f "${__sh_config}" ]; then
  echo "${__sh_config} not found, creating one"
  touch "${__sh_config}"
fi

__required_line=". ~/src/github.com/CodegemIO/cli/cli.sh"

if grep -Fxq "${__required_line}" "${__sh_config}"
then
  echo "codegem cli is already installed"
else
  echo "${__required_line}" >> "${__sh_config}"
  echo "codegem cli installed successfully, please restart your shell"
fi
