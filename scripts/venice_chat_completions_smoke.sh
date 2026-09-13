#!/usr/bin/env bash
set -euo pipefail

env_file="${HOME}/.config/private.env"

if [[ ! -f "${env_file}" ]]; then
    echo "Missing ${env_file}. Create it with VENICE_API_KEY set." >&2
    exit 1
fi

set -a
source "${env_file}"
set +a

if [[ -z "${VENICE_API_KEY:-}" ]]; then
    echo "VENICE_API_KEY is not set in ${env_file}." >&2
    exit 1
fi

curl --fail --silent --show-error \
    https://api.venice.ai/api/v1/chat/completions \
    -H "Authorization: Bearer ${VENICE_API_KEY}" \
    -H "Content-Type: application/json" \
    -d '{
    "model": "deepseek-v4-flash-0731",
    "messages": [
      {
        "role": "user",
        "content": "Reply with exactly: venice ok"
      }
    ],
    "max_tokens": 16
  }'
