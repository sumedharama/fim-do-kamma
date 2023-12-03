#!/usr/bin/env bash

# no trailing slash
OUT_DIR="./manuscript/markdown"

if [ ! -d "$OUT_DIR" ]; then
    echo "Folder doesn't exist: $OUT_DIR"
    exit 2
fi

for i in ./manuscript/tex/opening-quote.tex ./manuscript/tex/00-prefacio.tex ./manuscript/tex/00-nota-do-editor.tex ./manuscript/tex/01-onde-existe.tex ./manuscript/tex/02-kamma-luminoso.tex ./manuscript/tex/03-kamma-da-meditacao.tex ./manuscript/tex/04-kamma-e-memoria.tex ./manuscript/tex/05-observar-o-mundo.tex ./manuscript/tex/06-relacionamentos.tex ./manuscript/tex/07-existe-um-fim.tex ./manuscript/tex/99-notas-finais.tex
do
    echo -n "--- "$(basename $i)" to Markdown ... "

    name=$(basename -s .tex "$i")
    out_file="$OUT_DIR/$name.md"

    cat "$i" |\
    sed 's/\\fontsize.16..16.\\butlerFont\\selectfont//' |\
    grep -E -v '^ *\\bigskip$' |\
    grep -E -v '^ *\\enlargethispage\**[{][^}]+[}]$' |\
    grep -E -v '^ *\\thispagestyle[{][^}]+[}]$' |\
    sed 's/\\par/\n\n/g' |\
    sed 's/\\mainmatter//g' |\
    sed 's/\\centering//g' |\
    sed 's/\\raggedleft//g' |\
    sed 's/\\clearpage//g' |\
    sed 's/\\parskip//g' |\
    sed 's/\\mbox[{]\([^}]\+\)[}]/\1/g' |\
    sed 's/\\pagenote/\\footnote/g' |\
    sed 's/\\quoteRef/\\emph/g' |\
    sed 's/\\[hv]space\**[{][^}]\+[}]//' |\
    grep -E -v '^\\chapterNote[{][^}]+[}]$' |\
    sed 's/\\tocChapterNote/\\emph/g' |\
    sed 's/~/ /g' |\
    sed 's/\\ldots[{][}]/.../g' |\
    sed 's/\(\w\)"-\(\w\)/\1-\2/g' |\
    pandoc -f latex+smart -t markdown+smart --wrap=none > "$out_file"

    if [ "$?" == "0" ]; then
        echo "OK"
    else
        echo "ERROR, Exiting."
        exit 2
    fi
done
