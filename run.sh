#!/usr/bin/env bash
if [ -z $IN_DIR ]; then
  IN_DIR="$PWD"
fi

export OUT_DIR="static_files" # Overwrite here

INFRA="compose_infra.yml"
MODULES="compose_modules.yml"

docker-compose -f ${INFRA} down

# Comment out the next two lines to NOT generate documentation
# from source code. See 'docs/modules.md' for more information.
# NOTE: Ensure correct paths in 'compose_modules.yml'.
docker-compose -f ${MODULES} build
docker-compose -f ${MODULES} up

echo "Removing '$OUT_DIR'"
rm -rf $OUT_DIR

echo "Generating new HTML site in '$OUT_DIR'"
docker build -t doc-docs .

docker run -v "${IN_DIR}:/data:ro" \
           -v "${IN_DIR}/${OUT_DIR}:/data/${OUT_DIR}:rw" \
           -e "OUT_DIR=${OUT_DIR}" \
           doc-docs

mv "$IN_DIR/$OUT_DIR" .
cp -rf "img" "$OUT_DIR/img" || exit 0

echo "Running Nginx and PHP: http://localhost:8080"
docker-compose -f ${INFRA} up
