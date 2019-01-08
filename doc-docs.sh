#!/usr/bin/env bash
create_html_file() {
    tmpfile=`mktemp`
    tmpcontent=`mktemp`
    tmpfile_md=`mktemp`
    html_file="${1%.md}.html"
    dirname=`dirname $1`

    if [ "$1" = "$tmpindex" ]; then
        relative_path='.'
        cat $1 > $tmpfile_md
    else
        relative_path=`realpath --relative-to="$dirname" "${PWD}"`
        cat ${PAGE_HEAD} > $tmpfile_md
        cat $1 >> $tmpfile_md
        cat ${PAGE_TAIL} >> $tmpfile_md
    fi

    pandoc -f gfm $tmpfile_md -o $tmpcontent
    rm $tmpfile_md

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
tmptree=`mktemp`
tmptree_dirs=`mktemp`

echo "Creating tree..."
cat <<EOF > $tmptree
<pre><code>
EOF
time tree . -f --prune -P '*.md' >> $tmptree

time find . -type f -iname "*.md" -print0 | while IFS= read -r -d $'\0' file; do
    source_file=`echo "$file" | cut -d'/' -f2-`
    html_filename="${source_file%.md}.html"
    basename=`basename $html_filename`
    modified_date=`stat -c %y $source_file | awk -F ' ' '{print $1}'`

    create_html_file $source_file ${OUT_DIR}

    sed -i "s~$source_file~<a href='$html_filename'>$basename</a>~g" $tmptree
    cat <<EOF >> $tmplinks
$modified_date<DEL>$modified_date - [$html_filename]($html_filename)  
EOF
done
sed -i "s~\./~~g" $tmptree

# Don't process links and the following 'cat' code later. Could also delete each entry indivdually while processing above.
sed '\~\.html</a>$~d' $tmptree > $tmptree_dirs

cat <<EOF >> $tmptree
</code></pre>
<hr/>

EOF

echo "Prettifying tree..."
# Start reading at line 3. Each $dirpath occurs once in our tree command output.
time sed -n '3,$p' $tmptree_dirs | while IFS="" read -r line || [ -n "$line" ]; do
    dirpath=`echo "$line" | awk -F '── ' '{print $2}'`
    basename=`basename $dirpath`
    sed -i "s~── $dirpath$~── $basename~1" $tmptree
done
rm $tmptree_dirs

echo "Creating index..."
cat ${INDEX_HEAD} > $tmpindex
cat $tmptree >> $tmpindex && rm $tmptree
cat $tmplinks |
sort -r -b -k 1.1,1.4 -k 1.6,1.7 -k 1.9,1.10 |
awk -F '<DEL>' '{print $2}' >> $tmpindex && rm $tmplinks
cat ${INDEX_TAIL} >> $tmpindex

create_html_file $tmpindex ${OUT_DIR}
rm $tmpindex

mv "${OUT_DIR}$tmpdir/index.html" "${OUT_DIR}/index.html"
echo "Moved '${OUT_DIR}$tmpdir/index.html' to '${OUT_DIR}/index.html'"

rm -rf "${OUT_DIR}/tmp"
echo "Removed '${OUT_DIR}/tmp'"

echo "Done"
