#!/bin/sh

set -eu

# shellcheck disable=SC2312
echo "Hello $( [ -n "${*-}" ] && printf -- '%s' "${*}" || printf -- World)!"
