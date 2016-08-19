################################################################################
# Displays an error message and the optional line number, file name and exit
# code before exiting.
#
# ### Usage
#
# Generic error message (default):
# ```
#   Io.error
# ```
# This will cause your script to exit with exit code 1 after displaying a very
# generic error message. Not advisable. Verbose errors are preferred.
#
# Custom error message:
# ```
#   Io.error 'My error message'
# ```
# This is a little better. Your custom error message is displayed before the
# script is exited.
#
# Custom error message with line number and script name:
# ```
#   Io.error 'My error message' 42 'foo.sh'
# ```
# An error message along with the line number and script name are displayed
# before the exit. If you only supplied the line number or the file name, this
# function will not work. You have to either supply both or neither.
#
# Custom error message with line number and script name and exit code:
# ```
#   Io.error 'My error message' 42 'foo.sh' 2
# ```
# Same as above except the script will exit with the exit code '2'.
#
# ### Tips
#
# Consider using '${LINENO}' in scripts when you want to pass in the line number.
#
# @param string $1 optional
#     Custom error message.
# @param integer $2 optional
#     Line number where the error occurred. Must be used together with $3.
# @param string $3 optional
#     File name where the error occurred. Must be used together with $2.
# @param integer $4 optional
#     Exit code. Supplying this will cause the script to exit with the error
#     code in $4.
################################################################################
Io.error() {
  local -A placeholders
  local string

  Sheldon.Core.Libraries.load 'Sheldon.Util.String'

  case "$#" in
    0)
      # TODO: check for UTF-8 terminal before using Unicode.
      printf "$(< "${Sheldon[dir]}/resources/templates/errors/0.tpl")"
      ;;

    1)
      string="$(< "${Sheldon[dir]}/resources/templates/errors/1.tpl")"
      placeholders=( ['message']="${1}" )
      Sheldon.Util.String.insert =Sheldon_tmp "${string}" placeholders
      printf "${Sheldon_tmp}"
      ;;

    3|4)
      string="$(< "${Sheldon[dir]}/resources/templates/errors/$#.tpl")"
      placeholders=( ['message']="${1}" ['line']="${2}" ['file']="${3}" )
      Sheldon.Util.String.insert =Sheldon_tmp "${string}" placeholders
      printf "${Sheldon_tmp}"
      ;;

    *)
      echo "Invalid number of arguments ($#) for '_error()'"
  esac

  if [[ $# = 4 ]]; then
    exit $4
  fi
  exit 1
}