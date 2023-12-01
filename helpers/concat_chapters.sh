#!/usr/bin/env bash

DEST=chapters.tex

echo -n "" > "$DEST"

for i in ./manuscript/tex/opening-quote.tex ./manuscript/tex/00-prefacio.tex ./manuscript/tex/00-nota-do-editor.tex ./manuscript/tex/01-onde-existe.tex ./manuscript/tex/02-kamma-luminoso.tex ./manuscript/tex/03-kamma-da-meditacao.tex ./manuscript/tex/04-kamma-e-memoria.tex ./manuscript/tex/05-observar-o-mundo.tex ./manuscript/tex/06-relacionamentos.tex ./manuscript/tex/07-existe-um-fim.tex ./manuscript/tex/99-notas-finais.tex
do
    echo -en "\n\n" >> "$DEST"

    cat "$i" |\
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
    grep -E -v '^\\chapterNote[{][^}]+[}]$' |\
    sed 's/\\tocChapterNote/\\emph/g' |\
    sed 's/~/ /g' |\
    sed 's/\\ldots[{][}]/.../g' |\
    sed 's/\(\w\)"-\(\w\)/\1-\2/g' |\
    cat -s >> "$DEST"

    echo -en "\n\n" >> "$DEST"
done

cat -s "$DEST" > "$DEST.tmp"
mv "$DEST.tmp" "$DEST"

pandoc -f latex -t markdown "$DEST" > "$DEST.md"
