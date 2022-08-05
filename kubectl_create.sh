#!/bin/bash

set -e
eval "cat <<EOF
$(<$1)
EOF
" | kubectl create -f -
