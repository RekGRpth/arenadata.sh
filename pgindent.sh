#!/bin/bash -eux

(
if [[ "$GP_MAJOR" == "6c" || "$GP_MAJOR" == "6u" ]]; then
    cd "$HOME/src/gpdb$GP_MAJOR/src/tools/entab"
    make -j"$(nproc)"
    install -s entab "$BINDIR"
    rm -f "$BINDIR/detab"
    ln "$BINDIR/entab" "$BINDIR/detab"
    rm -r pg_bsd_indent* || echo $?
    wget --no-check-certificate https://ftp.postgresql.org/pub/dev/pg_bsd_indent-1.3.tar.gz
    tar -xf pg_bsd_indent-1.3.tar.gz
    make -j"$(nproc)" -C pg_bsd_indent
    install -s pg_bsd_indent/pg_bsd_indent "$BINDIR"
    rm -r pg_bsd_indent* || echo $?
elif [[ "$GP_MAJOR" == "7c" || "$GP_MAJOR" == "7u" || "$GP_MAJOR" == "8u" ]]; then
    cd "$HOME/src/pg_bsd_indent"
#    make -j"$(nproc)" clean
    make -j"$(nproc)" install
fi
cd "$HOME/src/gpdb$GP_MAJOR/src/tools/pgindent"
cp -f pgindent "$BINDIR"
) 2>&1 | tee "$HOME/pgindent.log"

