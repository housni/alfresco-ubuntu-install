# Out.header "My green & bold header text"
Out.header() {
  local length
  local before
  local after

  length=" $1 "
  length=${#length}
  before="$(tput bold)$(tput setaf 2)"
  after="$(tput sgr0)"

  printf "${before}-%.0s${after}" $(seq 1 $length)
  Out.green " $1 "
  printf "${before}-%.0s${after}" $(seq 1 $length)
  echo
}

# Out.red "My red bold text"
Out.red() {
  local before
  local after

  before="$(tput bold)$(tput setaf 1)"
  after="$(tput sgr0)"

  printf "\n${before}$1${after}\n"
}

# Out.green "My green bold text"
Out.green() {
  local before
  local after

  before="$(tput bold)$(tput setaf 2)"
  after="$(tput sgr0)"

  printf "\n${before}$1${after}\n"
}

# Out.blue "My blue bold text"
Out.blue() {
  local before
  local after

  before="$(tput bold)$(tput setaf 4)"
  after="$(tput sgr0)"

  printf "\n${before}$1${after}\n"
}
