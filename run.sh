#!/usr/bin/env bash
OUT_DIR="static_files"
docker-compose down

echo "Removing '$OUT_DIR'"
rm -rf $OUT_DIR

echo "Generating new HTML site in '$OUT_DIR'"
docker build -t doc-docs .
docker run -v "$PWD:/data:ro" -v "$PWD/$OUT_DIR:/data/$OUT_DIR:rw" doc-docs

echo "Running nginx and php: http://localhost:8080"
docker-compose up
