#!/bin/bash
#
# Updates the AsciiDoc sources of the site based on the Markdown sources in
# wiki/

set -e

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
    ruby "${SCRIPT_ROOT}/postprocess_section_headers.rb" "${tmpfname}" >"${tmpfname}.tmp"
    mv "${tmpfname}.tmp" "${tmpfname}"

    if [ -f "partials/header_$outfname" ]; then
        cat "partials/header_$outfname" >>$outfile
    else
        echo -e "= ${title}\n" >$outfile
    fi

    cat "${tmpfname}" >>$outfile

    rm -f "${outfname}.tmp"

    if [ -f "partials/footer_$outfname" ]; then
        cat "partials/footer_$outfname" >>$outfile
    fi

    if [ "x$base" != "xHome" ]; then
        echo "* xref:${outfname}[]" >>"${OUTDIR}/nav.adoc"
    fi
done

INDEX="${OUTDIR}/pages/index.adoc"

cat partials/header_index.adoc >"${INDEX}"
cat "${OUTDIR}/nav.adoc" >>"${INDEX}"
cat partials/footer_index.adoc >>"${INDEX}"

