#!/usr/bin/env bash

#
# USAGE:
#     curl -sL https://example.org/alfinit.sh | sudo -E bash -s -- -c /path/to/config.conf -
#     

# Set some strict options.
set -o errexit
set -o nounset
set -o pipefail

# Make sure we are on Bash v4.3, at least.
[[ ${BASH_VERSION} =~ ([^\.]).([^\.])* ]]
if [[ ${BASH_REMATCH[1]} < 4
   || ${BASH_REMATCH[1]} = 4 && ${BASH_REMATCH[2]} < 3 ]]; then
  echo "WARNING: This script has only been tested with Bash 4.3* but you are" \
       "using version ${BASH_VERSION}"
fi

# Usage instructions.
Install.usage() {
  echo "USAGE"
  echo "    $0 -c /path/to/config.conf"
}

# We only proceed with this script if PROCEED is set to 1, which is only done if
# a config file is specified.
PROCEED=0

# Parse out params.
while getopts ":c:" opt; do
  case $opt in
    c)
      # We source the config file here.
      . "$OPTARG"
      PROCEED=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      Install.usage
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      Install.usage
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

# Don't proceed if the config file is not specified.
if [ $PROCEED -eq 0 ]; then
    echo "Unspecified config file."
    Install.usage
    exit 1
fi

# This variable is populated in the module files.
# It's an associative array of all the URLs for the packages we need.
# Associatve arrays in Bash? Yeah, I know, there are better tools for this but
# we are using Bash.
declare -A PACKAGE_URLS

# Path to our downloaded includes.
declare -r PATH_INCLUDES="$LOFTUXAB_INSTALL_PATH/scripts/alfresco/includes"

# Path to our downloaded modules.
declare -r PATH_MODULES="$LOFTUXAB_INSTALL_PATH/scripts/alfresco/modules"

# Path to our temporary directory.
declare -r TEMP_DIR="/tmp/$(cat /proc/sys/kernel/random/uuid)"

# Installs packages using the native OS package manager.
# 
# If we do implement this for other distributions, we have to consider the fact
# that different distributions have different package names so we'll have to
# map the names across.
#
# Usage:
#     Package.install curl
#     Package.install curl wget vim
Package.install() {
    if [ -f /etc/debian_version ]; then
        sudo apt-get -qqy install $@
    elif [ -f /etc/redhat-release ]; then
        # rpm command here.
        :
    fi
}

# Checks to see if a package is installed, if it isn't, it will be installed.
# 
# Usage:
#     Package.required wget 
Package.required() {
  command -v $1 >/dev/null 2>&1 || {
      echo
      echo "    $1 is not installed. Installing it now..." >&2
      echo
      Package.install $1
  }
}

# Downloads required installation scripts and sources them.
# Usage:
#     Install.scripts includes $PATH_INCLUDES foo.sh bar.sh
#     Install.scripts modules $PATH_MODULES baz.sh bam.sh
Install.scripts() {
  local -r segment=$1
  local -r path=$2

  shift 2
  for file in "$@"
  do
      wget --output-document="$path/$file" \
           "$LOFTUXAB_BASE_URL/scripts/alfresco/$segment/$file"
      . "$path/$file"
  done
}

# Install prerequisites.
Package.required wget
Package.required curl

# Create our drectories to house our scripts.
sudo mkdir -p "$LOFTUXAB_INSTALL_PATH"/scripts/alfresco/{includes,modules}

# Download and source our includes.
Install.scripts includes $PATH_INCLUDES out.sh io.sh

# Download and source our modules.
Install.scripts modules $PATH_MODULES "${LOFTUXAB_MODULES[@]}"

mkdir $TEMP_DIR && cd $TEMP_DIR



exit


for PACKAGE_URLS in "${!PACKAGE_URLS[@]}"
do
  echo $PACKAGE_URLS --- ${PACKAGE_URLS[$K]}
#  if [[ $(wget -S --spider --no-check-certificate ${PACKAGE_URLS[$K]}  2>&1 | grep 'HTTP/1.1 200 OK') ]]; then
#    # Valid URL
#  fi
done





Install.summary() {
    # output what options we are using from config.conf
}

Pre.summary


# TODO: Set traps
cleanup() {
  rm -f $TEMP_DIR
}

trap "cleanup" EXIT

exit 0