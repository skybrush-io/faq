#!/bin/bash
#
# Updates the AsciiDoc sources of the site based on the Markdown sources in
# wiki/

SCRIPT_ROOT="`dirname $0`"
cd "${SCRIPT_ROOT}/.."

REPO_ROOT="`pwd`"
WIKI="${REPO_ROOT}/wiki"
OUTDIR="modules/ROOT"

bundle install --quiet

rm -f "${OUTDIR}/nav.adoc"

for file in `ls -v "${WIKI}"/*.md | grep -v "Home.md"`; do
    base=`basename "$file" .md`
    title="`echo \"$base\" | tr '_-' '  '`"
    outfname=`echo "$base" | tr '[:upper:]' '[:lower:]'`.adoc
    tmpfname="${outfname}.tmp"
    outfile="${OUTDIR}/pages/$outfname"

    bundle exec kramdoc --format=GFM --wrap=ventilate -o "${tmpfname}" $file

    echo -e "= ${title}\n" >$outfile
    cat "${tmpfname}" >>$outfile

    rm -f "${outfname}.tmp"

    echo "* xref:${outfname}[]" >>"${OUTDIR}/nav.adoc"
done

