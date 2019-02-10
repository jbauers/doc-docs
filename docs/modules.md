# Modules

You can generate markdown files from source code (to then be converted to HTML)
by uncommenting the relevant lines and specifying the path to your files in
`compose_modules.yml`.

This will mount those directories `rw` and create `*.md` files in them, depending
on the module. Please check the Dockerfiles for each module in `modules/<module>`
and ensure none of your files will be overwritten. You can edit the generated
filename there.

Modules are independent from each other, so you can only run what you need to run.
When enabled, each time you run `run.sh`, images will be rebuilt and new files are
generated.
