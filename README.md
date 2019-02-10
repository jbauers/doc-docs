# :whale: doc-docs

Generate static HTML documentation from source code - indexed across projects, flexible, with
"batteries" included.

## What?

You have some markdown files in the `gfm` format and want to convert them to static HTML files
that look like Github's README files. Using modules, you can optionally generate markdown from
source code before converting to HTML. Currently supported modules are:

- [Ansible](modules/) using [ansible-docgen](https://github.com/jbauers/ansible-docgen)
- [Puppet](modules/) using [puppet-strings](https://github.com/puppetlabs/puppet-strings)
- [Terraform](modules/) using [terraform-docs](https://github.com/segmentio/terraform-docs)

To add modules, check the above integrations in `modules/<module>/Dockerfile`. Additional modules
should be integrated in a similar way. Also see [modules](docs/modules.md) for more information.

The goal is to keep it simple, so you can edit the source code in a few places to get a setup that
works the way you want it to. It's basically all shell code and fully Docker based - some light
config files are included, too.

## Why?

- You want to generate and centralize documentation from source code across projects and languages
- You want to index and maybe search your docs
- You want to view docs locally in your browser or spin up an Nginx container
- You don't want to make API calls to Github or host your docs there
- You want emojis and stuff without the overhead :rocket:

# Quickstart

Clone this repository, build pandoc, generate HTML, and run PHP and Nginx:

```
git clone https://github.com/jbauers/doc-docs.git
cd doc-docs
IN_DIR="/path/to/files" ./run.sh
```

# Requirements

- [Docker](https://docs.docker.com/install/)
- [docker-compose](https://docs.docker.com/compose/install/) if you want basic search functionality
and/or use modules

## Usage

`IN_DIR="/path/to/files" ./run.sh` in the `doc-docs` root.

Change `/path/to/files` to whatever dir you want to index. doc-docs will find and convert all
mardown files and create `static_files` in the `doc-docs` root. `static_files` will be recreated
each time you run `./run.sh`. If no `IN_DIR` is defined, doc-docs will generate its own
documentation. To change the `OUT_DIR`, see [`run.sh`](run.sh).

Adjust [`compose_modules.yml`](compose_modules.yml) and uncomment the relevant lines in `run.sh`
to additionally generate markdown from source code, before also converting it to HTML.

## Structure

For examples on how to structure your docs and use cases, see [structure](docs/structure.md).

# Motivation

I feel most "wikis" are overblown. I want something really simple that looks pretty enough, indexes
my files and makes them searchable, nothing more. If I want authentication, I can do that with
Nginx and LDAP. I don't need to edit my files in the browser and I don't want the overhead to
enable this. I just want to view and search stuff, and it should be fast.

# Notes

Edit the scripts and files ([`doc-docs.sh`](doc-docs.sh), [`config/*`](config/)) to suit your needs
. They are small, it should be simple to modify them to make your docs look like you want them to.

Building pandoc may take a while. Only the `gfm` part is needed, so this image could (should)
probably be made a lot smaller (currently ~231MB). It outputs static HTML files, so worst case
you can run this image and delete it afterwards. Except for the `static_files` folder, this leaves
nothing else on your system (unless modules are enabled). Only the first build is slow.
