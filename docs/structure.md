# Structure

doc-docs makes no assumptions on how you structure your docs. It does create an `index.html`,
but otherwise takes the current structure and simply converts `file.md` -> `file.html`.

Since all paths are relative, you can reference other files easily.

You can run doc-docs however you like:

- If you have a big umbrella project, run it there to index everything.
- If you have small projects, run it on each of them. You will need to make your own index,
referencing the created indexes (or do it all on your own).

Note that searching will get slower as the project gets bigger. There's probably some
optimisations to be made there :smile:

## "Pull" example

Add all projects you'd like to generate documentation of as `.gitmodules`, under one umbrella dir.
Adjust `IN_DIR=/path/to/umbrella` and modules in `.env` and run `run.sh`.

## "Push" example

Have a CI/CD system that runs `run.sh` in a job. Rsync resulting `static_files` individually
per project to their corresponding folders on the remote.
