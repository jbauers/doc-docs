#!/usr/bin/env bash
source .env

docker-compose -f ${COMPOSE_INFRA} down

if [ "${MODULES}" = true ] ; then
  docker-compose -f ${COMPOSE_MODULES} build
  docker-compose -f ${COMPOSE_MODULES} up
fi

echo "Removing '$OUT_DIR'"
rm -rf $OUT_DIR

echo "Generating new HTML site in '$OUT_DIR'"
docker build -t doc-docs .

docker run -v "${IN_DIR}:/data:ro" \
           -v "${IN_DIR}/${OUT_DIR}:/data/${OUT_DIR}:rw" \
           -e "OUT_DIR=${OUT_DIR}" \
           -e "UID=$(id -u)" \
           -e "GID=$(id -g)" \
           doc-docs

mv "$IN_DIR/$OUT_DIR" .
cp -rf "img" "$OUT_DIR/img" || exit 0

echo "Running Nginx and PHP: http://localhost:8080"
docker-compose -f ${COMPOSE_INFRA} up
