#!/bin/bash

echo "# CTF README" > README.md
echo "" >> README.md
echo "Ce README contient des liens cliquables pour accéder aux fichiers du dossier \`log$\`." >> README.md
echo "" >> README.md
echo "## Fichiers" >> README.md
echo "" >> README.md

for file in writeups/*; do
    if [ -d "$file" ]; then
        continue
    filename=$(basename -- "$file")
    filename="${filename%.*}"
    echo "- [$filename](writeups/$filename.md)" >> README.md
done

echo "" >> README.md
echo "N'hésitez pas à explorer ces fichiers pour résoudre le CTF !" >> README.md