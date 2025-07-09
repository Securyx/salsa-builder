#!/bin/bash
set -euo pipefail

hash=$(sha256sum "${ARTIFACT}" | awk '{print $1}')
subject_name=$(basename "$(readlink -m "${ARTIFACT}")")
printf -v subjects \
  '{"name": "%s", "digest": {"sha256": "%s"}}' \
  "$subject_name" "$hash"

cat <<EOF >DATA
{
    "version": 1,
    "attestations":
    [
        {
            "name": "$(basename "${ARTIFACT}")",
            "subjects":
            [
                ${subjects}
            ]
        }
    ]
}
EOF

jq <DATA

cat DATA >"$SLSA_OUTPUTS_ARTIFACTS_FILE"
