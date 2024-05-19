#!/bin/bash

echo "# CTF README" > README.md
echo "" >> README.md
echo "Ce README contient des liens cliquables pour accéder aux fichiers du dossier \`log$\`." >> README.md
echo "" >> README.md
echo "## Boxes" >> README.md
echo "" >> README.md

for dir in writeups/*; do
    echo "### $(echo $dir | cut -d'-' -f2-)" >> README.md
    echo "" >> README.md

    for file in "$dir"/*.md; do
        if [ ! -f "$file" ]; then
            echo "No files found in $dir"
            continue
        fi
        filename=$(basename -- "$file")
        filename="${filename%.*}"
        link="${dir// /%20}/$filename.md"
        echo "- [$filename]($link)" >> README.md
    done

    echo "" >> README.md
done

echo "" >> README.md
echo "N'hésitez pas à explorer ces fichiers pour résoudre le CTF !" >> README.md