# Requirements

- [Docker](https://docs.docker.com/install/)
- [docker-compose](https://docs.docker.com/compose/install/)

# Building and running

**Note:** Building pandoc may take a while. Only the `gfm` part is needed, so this 
image could (should) probably be made a lot smaller (currently ~220MB).

Clone this repository, build pandoc and run php and nginx:

```
git clone https://.../jbauers/doc-docs
cd doc-docs
docker-compose up
```

This will get you up and running and launch doc-docs [docs](docs/README.html) :whale:

