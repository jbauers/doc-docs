# Pandoc

Most of the Dockerfile to build pandoc is taken from [portown/alpine-pandoc](https://github.com/portown/alpine-pandoc),
adding the stylesheet, `doc-docs.sh` and heads and tails.

## Building the image

Building pandoc may take a while. Only the `gfm` part is needed, so this image could (should)
probably be made a lot smaller (currently ~231MB). Only the first build is slow.

To compile pandoc from source, adding doc-docs configs:

`docker build -t doc-docs .`

Changing `doc-docs.sh`, or page heads/tails won't take much time. `run.sh` will rebuild your image,
so you can adjust those quickly.

## Converting pages

`doc-docs.sh` will recursively convert `*.md` in the current directory to static `*.html`
files, put them into `static_files` and create an index. It keeps the directory structure and
takes care of updating paths to `style.css`, so everything looks pretty when you view it :smile:

To only convert the files, run:

`docker run -v $PWD:/data:ro -v $PWD/static_files:/data/static_files:rw doc-docs`

You can then navigate to your `*.html` files in the browser.

# Infra setup

To launch Nginx to view your files:

`docker run -v $PWD/static_files:/usr/share/nginx/html:ro -p 8080:80 nginx`

To enable search, you also need PHP and the included code. Have a look at the included
`compose_infra.yml`, `run.sh`, `config/php/search.php` and `config/nginx/sites.conf`. All code is
very basic, so you can adjust those to your needs.
