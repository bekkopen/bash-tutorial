_assertEquals() {
  local arguments=( "$@" )
  local expected="${1}"
  local actual="${2}"
  local msg="${arguments[@]:2}"
  [[ "${expected}" == "${actual}" ]] && _info "test passed! (value=${actual}) ${msg}" || _fatal "test failed! Expected value ${expected} but was ${actual} ${msg}"
  [[ $1 =~ "^[0-9]+$" ]] && return ${actual}  || return 0
}

_assertTrue() {
  _assertEquals 0 ${1}
}

