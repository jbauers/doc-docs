#!/usr/bin/env bash
if [ -z $IN_DIR ]; then
  IN_DIR="$PWD"
fi
OUT_DIR="static_files"
docker-compose down

echo "Removing '$OUT_DIR'"
rm -rf $OUT_DIR

echo "Generating new HTML site in '$OUT_DIR'"
docker build -t doc-docs .
docker run -v "$IN_DIR:/data:ro" -v "$IN_DIR/$OUT_DIR:/data/$OUT_DIR:rw" doc-docs
mv "$IN_DIR/$OUT_DIR" .

echo "Running nginx and php: http://localhost:8080"
docker-compose up
