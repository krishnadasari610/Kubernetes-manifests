#!/bin/bash

set -e
eval "cat <<EOF
$(<$1)
EOF
" | kubectl delete -f -
