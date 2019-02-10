# Modules

doc-docs supports generating markdown from source code, to then be converted to HTML, by taking
existing `<code>` to `.md` converters, putting them in a Docker container, and running them over
your source code directories. Check the [`modules/`](../modules/) directory to get an idea.

Modules are independent of each other, so you can only run what you need to run. When enabled,
each time you run `run.sh`, images will be rebuilt and new files are generated.

## Using modules

Edit the `.env` file to adjust directory paths, or disable modules completely by setting `MODULES`
to `false`. If enabled, running `run.sh` will mount those directories `rw` and create `*.md` files
in them, naming dependent on the module.

Please check the Dockerfiles for each module in `modules/Dockerfile.<module>` and ensure none of
your files will be overwritten. You can edit the generated filename there.

## Issues

While modules can work out of the box with your code, you may need to tweak the commands in the
corresponding Dockerfiles to generate documentation that respects your coding style. Or tweak your
code to work with the converter used... :wink:

Using `run.sh`, only one `IN_DIR` per module is supported - depending on the module and your code,
a lot of documentation may not be generated because of this. You can manually run each module
to generate markdown files first, and run the `doc-docs` container afterwards if needed. Or tweak
the command in `module/Dockerfile.<module>`, if the converter used supports it. Adding support for
more than one `IN_DIR` per module is planned.
