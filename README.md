# :whale: doc-docs

Generate static HTML documentation from source code - indexed across projects, flexible, with
"batteries" included.

## What?

You have some markdown files in the `gfm` format and want to convert them to static HTML files,
looking like Github's documentation. By using modules, you can optionally generate markdown from
source code before converting to HTML.

Currently supported:

- [Ansible](modules/) using [ansible-docgen](https://github.com/jbauers/ansible-docgen)
- [Golang](modules/) using [godoc2md](https://github.com/davecheney/godoc2md)
- [Puppet](modules/) using [puppet-strings](https://github.com/puppetlabs/puppet-strings)
- [Terraform](modules/) using [terraform-docs](https://github.com/segmentio/terraform-docs)

See [Quickstart](#quickstart) to spin up an example website - code examples are provided in
[docs/examples](docs/examples/). Note that the first build will be slow (pandoc from source takes a
while). Subsequent runs are much faster.

## Why?

- You want to generate and centralize documentation from source code, across projects and languages
- You want to index and maybe search your docs
- You want to view docs locally in your browser or spin up an Nginx container
- You don't want to make API calls to Github or host your docs there
- You want emojis and stuff without the overhead :rocket:

# Quickstart

1. Clone this repository and enter `doc-docs` directory:
```
git clone https://github.com/jbauers/doc-docs.git
cd doc-docs
```

2. Initialize and update submodules:
```
git submodule init
git submodule update
```

3. Run doc-docs:
```
./run.sh
```

This will:
- Build pandoc and modules
- Generate markdown from the example code
- Generate and index static HTML files from markdown
- Run PHP (for search) and Nginx @ http://localhost:8080

# Usage

Adjust the [`.env`](.env) file to point to your directories. You can also disable modules there.
Then, run
```
./run.sh
````
in the `doc-docs` root directory.

Edit the scripts and config files ([`doc-docs.sh`](doc-docs.sh), [`config/`](config/)) to suit
your needs. They are small, it should be simple to modify them to make your docs look like you want
them to.

## Requirements

- [Docker](https://docs.docker.com/install/)
- [docker-compose](https://docs.docker.com/compose/install/), if you want basic search
functionality and/or use modules

# Notes

The goal is to keep it simple, so you can edit the source code in a few places to get a setup that
works the way you want it to. It's basically all shell code and fully Docker based - some light
config files are included, too.

## Building pandoc

See [building](docs/building.md) for more information.

## Using modules

See [modules](docs/modules.md) for more information.

## Use cases

See [structure](docs/structure.md) for more information.

## Stylesheet

The stylesheet is taken from [sindresorhus/github-markdown-css](https://github.com/sindresorhus/github-markdown-css).
Only `github-markdown.css` is used.

# Motivation

I feel most "wikis" are overblown. I want something really simple that looks pretty enough, indexes
my files and makes them searchable, nothing more. If I want authentication, I can do that with
Nginx and LDAP. I don't need to edit my files in the browser and I don't want the overhead to
enable this. I just want to view and search stuff, and it should be fast.

