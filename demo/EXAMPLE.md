# Setup

- Docker

# Building image

`docker build -t www-docs .`

# Converting pages

`docker run -v $PWD:/data:ro -v $PWD/www-data:/data/www-data:rw www-docs`

# Examples
[Readme](../README.html)
