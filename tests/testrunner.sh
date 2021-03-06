#!/usr/bin/env bash
# testrunner.sh
#
# Copyright (C) 2006-2008  Jürg Billeter
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
#
# Author:
# 	Jürg Billeter <j@bitron.ch>

builddir=$PWD
topbuilddir=$TOPBUILDDIR
topsrcdir=$TOPSRCDIR
vapidir=$topsrcdir/vapi

export G_DEBUG=fatal_warnings
export PKG_CONFIG_PATH=$topbuilddir/src/libvaladoc
export LD_LIBRARY_PATH=$topbuilddir/src/libvaladoc/.libs

VALAC=valac
VALAFLAGS="-X -D -X TOP_SRC_DIR=\"$topsrcdir\" --vapidir $topbuilddir/src/libvaladoc --pkg valadoc-1.0 --pkg gee-0.8 --disable-warnings --main main --save-temps -X -g -X -O0 -X -pipe -X -lm -X -Werror=return-type -X -Werror=init-self -X -Werror=implicit -X -Werror=sequence-point -X -Werror=return-type -X -Werror=uninitialized -X -Werror=pointer-arith -X -Werror=int-to-pointer-cast -X -Werror=pointer-to-int-cast -X -L$topbuilddir/src/libvaladoc/.libs -X -I$topbuilddir/src/libvaladoc $topsrcdir/tests/libvaladoc/parser/generic-scanner.vala $topsrcdir/tests/drivers/generic-api-test.vala"

testdir=_test
rm -rf $testdir
mkdir $testdir
cd $testdir

echo -n -e "TEST: Building...\033[72G"

cat << "EOF" > checkall
all=0
fail=0
EOF

cat << "EOF" > main.vala
void main (string[] args) {
	switch (args[1]) {
EOF

PACKAGES=gio-2.0
SOURCEFILES=
for testfile in "$@"; do
	rm -f prepare check
	echo 'set -e' >> prepare

	case "$testfile" in
	*.vala)
		testpath=${testfile/.vala/}
		ns=${testpath//\//.}
		ns=${ns//-/_}
		SOURCEFILE=$ns.vala
		SOURCEFILES="$SOURCEFILES $SOURCEFILE"

		echo "	case \"/$testpath\": $ns.main (); break;" >> main.vala
		echo "namespace $ns {" > $SOURCEFILE
		cat "$topsrcdir/tests/$testfile" >> $SOURCEFILE
		echo "}" >> $SOURCEFILE

		echo "./test$EXEEXT /$testpath" > check
		;;
	esac

	cat prepare check > $ns.check
	cat << EOF >> checkall
echo -n -e "  /$testpath: \033[72G"
((all++))
if bash $ns.check &>log; then
	echo -e "\033[0;32mOK\033[m"
else
	((fail++))
	echo -e "\033[0;31mFAIL\033[m"
	cat log
fi
EOF
done

cat << "EOF" >> checkall
if [ $fail -eq 0 ]; then
	echo "All $all tests passed"
else
	echo "$fail of $all tests failed"
	exit 1
fi
EOF

cat << "EOF" >> main.vala
	default: assert_not_reached ();
	}
}
EOF

cat $SOURCEFILES >> main.vala

if $VALAC $VALAFLAGS -o test$EXEEXT $([ -z "$PACKAGES" ] || echo $PACKAGES | xargs -n 1 echo -n " --pkg") main.vala &>log; then
	echo -e "\033[0;32mOK\033[m"
else
	echo -e "\033[0;31mFAIL\033[m"
	cat log

	cd $builddir
	exit 1
fi

if bash checkall; then
	cd $builddir
	rm -rf $testdir
else
	cd $builddir
	exit 1
fi

