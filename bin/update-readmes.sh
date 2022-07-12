#!/bin/bash
set -e

echo "Pulling docker image..."
docker pull quay.io/terraform-docs/terraform-docs:latest > /dev/null

function generateDocs() {
  echo "Updating README.md in '$d'..."
  cd $1
  docker run --rm -v "$(pwd):/terraform-docs" -w "/terraform-docs" \
    quay.io/terraform-docs/terraform-docs:latest markdown . --output-file README.md --header-from .terraform-docs.header.md
  echo ""
}

for d in modules/*/ ; do
  (generateDocs $d)
done
