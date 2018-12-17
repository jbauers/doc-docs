# Structure

doc-docs makes no assumptions on how you structure your docs. It does create an `index.html`, 
but otherwise takes the current structure and simply converts `file.md` -> `file.html`.

Since all paths are relative, you can reference other files easily.

You can run `doc-docs` however you like: 

- If you have a big umbrella project, run it there to index everything.
- If you have small projects, run it on each of them. You will need to make your own index, referencing the created indexes (or do it all on your own).

Note that searching will get slower as the project gets bigger (duh). There's probably some 
optimisations to be made there 🙂
