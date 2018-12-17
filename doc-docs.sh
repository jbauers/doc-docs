#!/usr/bin/env bash
create_html_file() {
    tmpfile=`mktemp`
    tmpcontent=`mktemp`

    html_file="${1%.md}.html"
    dirname=`dirname $1`

    if [ "$1" = "$tmpdir/index.md" ]; then
        relative_path='.'
    else
        relative_path=`realpath --relative-to="$dirname" "${PWD}"`
    fi

    pandoc -f gfm $1 -o $tmpcontent

    cat <<EOF > $tmpfile
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta charset="UTF-8"> 
<link rel="stylesheet" href="$relative_path/style.css">
<article class="markdown-body">
EOF
    cat $tmpcontent >> $tmpfile && rm $tmpcontent
    cat <<EOF >> $tmpfile
</article>
EOF

    mkdir -p "$2/$dirname"
    mv $tmpfile "$2/$html_file"
    echo "Created '$2/$html_file'"
}

mkdir -p ${OUT_DIR}
cp ${STYLESHEET} "${OUT_DIR}/style.css"
echo "Created '${OUT_DIR}' and copied '${STYLESHEET}'"

tmpdir=`mktemp -d`
tmpindex="$tmpdir/index.md"
tmplinks=`mktemp`

time find . -type f -iname "*.md" -print0 | while IFS= read -r -d $'\0' file; do
    source_file=`echo "$file" | cut -d'/' -f2-`

    create_html_file $source_file ${OUT_DIR}

    cat <<EOF >> $tmplinks
[${source_file%.md}.html](${source_file%.md}.html)  
EOF
done

cat ${INDEX_HEAD} > $tmpindex
cat $tmplinks | sort >> $tmpindex && rm $tmplinks
cat ${INDEX_TAIL} >> $tmpindex

create_html_file $tmpindex ${OUT_DIR}
rm $tmpindex

mv "${OUT_DIR}$tmpdir/index.html" "${OUT_DIR}/index.html"
echo "Moved '${OUT_DIR}$tmpdir/index.html' to '${OUT_DIR}/index.html'"

rm -rf "${OUT_DIR}/tmp"
echo "Removed '${OUT_DIR}/tmp'"

echo "Done:"
tree ${OUT_DIR}
