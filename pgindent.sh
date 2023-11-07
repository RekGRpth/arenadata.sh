#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/src/tools/entab"
make -j"$(nproc)"
install -s entab "$BINDIR"
rm -f "$BINDIR/detab"
ln "$BINDIR/entab" "$BINDIR/detab"
cd "$HOME/src/gpdb$GP_MAJOR/src/tools/pgindent"
cp -f pgindent "$BINDIR"
#rm -r pg_bsd_indent*
rm -r pg_bsd_indent* || echo $?
wget --no-check-certificate https://ftp.postgresql.org/pub/dev/pg_bsd_indent-1.3.tar.gz
tar -xf pg_bsd_indent-1.3.tar.gz
make -j"$(nproc)" -C pg_bsd_indent
install -s pg_bsd_indent/pg_bsd_indent "$BINDIR"
rm -r pg_bsd_indent* || echo $?
) 2>&1 | tee "$HOME/pgindent.log"

