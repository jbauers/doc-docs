# Pandoc

Most of the Dockerfile to build pandoc is taken from [portown/alpine-pandoc](https://github.com/portown/alpine-pandoc), adding the stylesheet, `doc-docs.sh` and the index head and tail.

# Stylesheet

The stylesheet is taken from [sindresorhus/github-markdown-css](https://github.com/sindresorhus/github-markdown-css). Only `github-markdown.css` is used.

# Building the image

`docker build -t doc-docs .`

# Converting pages

The following command will recursively convert `*.md` in the current directory to static `*.html` 
files, put them into `static_files` and create an index. It keeps the directory structure and 
takes care of updating paths to `style.css`, so everything looks pretty when you view it :smile:

`docker run -v $PWD:/data:ro -v $PWD/static_files:/data/static_files:rw doc-docs`

You can now launch nginx to view your files:

`docker run -v $PWD/static_files:/usr/share/nginx/html:ro -p 8080:80 nginx`

If you want to enable search, you also need php. Have a look at the included `docker-compose.yml` 
and `run.sh`.
