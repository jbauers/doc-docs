# :whale: doc-docs

- You have some markdown files in the `gfm` format
- You want to convert them to static files and index them
- They should look pretty, like Github's markdown, with emojis and stuff :rocket:
- You don't want to make API calls to Github or host your docs there
- You want to view docs locally or just spin up a simple `nginx` container to view them
- Maybe you want to search them, too

`TL;DR`: Gimme some simple Github-like docs

# Motivation

I feel most "wikis" are overblown. I want something really simple that looks pretty enough, indexes 
my files and makes them searchable, nothing more. If I want authentication, I can do that with 
`nginx` and LDAP. I don't need to edit my files in the browser and I don't want the overhead to 
enable this. I just want to view and search stuff, and it should be fast.

# Requirements

- [Docker](https://docs.docker.com/install/)
- To enable search, [docker-compose](https://docs.docker.com/compose/install/)

# Quickstart

**Note:** Building pandoc may take a while. Only the `gfm` part is needed, so this 
image could (should) probably be made a lot smaller (currently ~231MB). It outputs static html 
files, so worst case you can run this image and delete it afterwards. Except for the `static_files` 
folder, this leaves nothing else on your system. Docker layers make sure that 
when changing `config/*` files, just those will be rebuilt, making only the first build slow.

Clone this repository, build pandoc and run php and nginx (ie, enable search):

```
git clone https://github.com/jbauers/doc-docs.git
cd doc-docs
IN_DIR="/path/to/files" ./run.sh
```

This will get you up and running and launch doc-docs [docs](docs/BUILDING.html) :whale:

Edit the scripts and files (`doc-docs.sh`, `config/*`) to suit your needs. 
They are small, it should be simple to modify them to make your docs look like you want them to.

