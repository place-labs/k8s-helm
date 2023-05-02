#!/usr/bin/env bash

set -euf -o pipefail

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$BASE_DIR"

values_file="$BASE_DIR/../placeos/values-local.yaml"
helm install dev -f "${values_file},$BASE_DIR/placeos-test-values.yaml" "$BASE_DIR/../placeos"