# release file makefile for pyukiwiki
# $Id: build.mk,v 1.72 2006/09/29 09:11:31 papu Exp $

all:
	@echo "PyukiWIki ${VERSION} Release Builder"
	@echo "Usage: ${MAKE} [build|prof|test|pkg|cvsupdate|clean|cvsclean]"

version:
	@echo "PyukiWIki ${VERSION}"

pkg:
	@${MAKE} -f ${BUILDDIR}/build.mk cvsclean
	@${MAKE} -f ${BUILDDIR}/build.mk pkgzip PKGTYPE=devel PKGPREFIX="-devel"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgzip PKGTYPE=updatecompact PKGPREFIX="-update-compact"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgzip PKGTYPE=update PKGPREFIX="-update-full"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgzip PKGTYPE=compact PKGPREFIX="-compact"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgzip PKGTYPE=release PKGPREFIX="-full"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=updatecompact PKGPREFIX="-update-compact"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=update PKGPREFIX="-update-full"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=devel PKGPREFIX="-devel"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=compact PKGPREFIX="-compact"
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=release PKGPREFIX="-full"

test:FORCE
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-full 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-update 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-compact 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-update-compact 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}-devel 2>/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-full"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-full "release" lf #>/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-compact"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-compact "compact" lf >/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-update"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-update "update" lf >/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-update-compact"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-update-compact "updatecompact" lf >/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-devel"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}-devel "devel" lf >/dev/null

buildrelease:FORCE
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@echo "Building ${PKGNAME}-${VERSION}-full"
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/ "release" lf >/dev/null

cvsupdate:
	@echo "Updating CVS"
#	@rm -rf ${TEMP} ${RELEASE}
	@${SH} ${BUILDDIR}/cvs.sh init ${CVSDIR}
	@${PERL} -e 'mkdir("${CVSDIR}");' 2>/dev/null
	@${PERL} -e 'mkdir("${CVSDIR}/${CVSNAME}");' 2>/dev/null
	@${PERL} ${BUILDDIR}/build.pl ${CVSDIR}/${CVSNAME} cvs lf
	@${SH} ${BUILDDIR}/cvs.sh update ${CVSDIR}
	@${SH} ${BUILDDIR}/cvs.sh commit ${CVSDIR}
	@${SH} ${BUILDDIR}/cvs.sh init ${CVSDIR}
	@${SH} ${BUILDDIR}/cvs.sh makesums ${CVSDIR} ${CVSNAME}
	@${SH} ${BUILDDIR}/cvs.sh update ${CVSDIR}
	@${SH} ${BUILDDIR}/cvs.sh commit ${CVSDIR}

cvsoverride:
	@echo "Override CVS"
#	@rm -rf ${TEMP} ${RELEASE}
	@${SH} ${BUILDDIR}/cvs.sh init ${CVSDIR}
	@${PERL} -e 'mkdir("${CVSDIR}");' 2>/dev/null
	@${PERL} -e 'mkdir("${CVSDIR}/${CVSNAME}");' 2>/dev/null
	@${PERL} ${BUILDDIR}/build.pl ${CVSDIR}/${CVSNAME} touch lf >/dev/null
	@${PERL} ${BUILDDIR}/build.pl ${CVSDIR}/${CVSNAME} cvs lf >/dev/null
	@${SH} ${BUILDDIR}/cvs.sh update ${CVSDIR}
	@${SH} ${BUILDDIR}/cvs.sh commit ${CVSDIR}
	@${SH} ${BUILDDIR}/cvs.sh init ${CVSDIR}
	@${SH} ${BUILDDIR}/cvs.sh makesums ${CVSDIR} ${CVSNAME}
	@${SH} ${BUILDDIR}/cvs.sh update ${CVSDIR}
	@${SH} ${BUILDDIR}/cvs.sh commit ${CVSDIR}

pkgtgz:
	@echo "Building ${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz"
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX} 2>/dev/null
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX} ${PKGTYPE} lf >/dev/null
	@cd ${RELEASE} && ${TAR} ${PKGNAME}-${VERSION}${PKGPREFIX}.tar * >/dev/null 2>/dev/null
#	@cd ${RELEASE} && ${GZIP} ${PKGNAME}-${VERSION}${PKGPREFIX}.tar >/dev/null 2>/dev/null
	@cd ${RELEASE} && ${GZIP_7Z} ${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz ${PKGNAME}-${VERSION}${PKGPREFIX}.tar >/dev/null 2>/dev/null
	@rm ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar
	@${PERL} -e 'mkdir("${ARCHIVEDIR}/${PKGNAME}-${VERSION}");' 2>/dev/null
	@cp ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz ${ARCHIVEDIR}/${PKGNAME}-${VERSION}
	@rm ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz

pkgzip:
	@echo "Building ${PKGNAME}-${VERSION}${PKGPREFIX}.zip"
	@rm -rf ${TEMP} ${RELEASE}
	@mkdir ${TEMP} 2>/dev/null
	@mkdir ${RELEASE} 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX} 2>/dev/null
	@${PERL} ${BUILDDIR}/build.pl ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX} ${PKGTYPE} crlf >/dev/null
#	@cd ${RELEASE} && ${ZIP} zip.zip ${PKGNAME}-${VERSION}${PKGPREFIX}/* >/dev/null 2>/dev/null
	@cd ${RELEASE} && ${ZIP_7Z} zip.zip ${PKGNAME}-${VERSION}${PKGPREFIX}/* >/dev/null 2>/dev/null
	@${PERL} -e 'mkdir("${ARCHIVEDIR}/${PKGNAME}-${VERSION}");' 2>/dev/null
	@cp ${RELEASE}/zip.zip ${ARCHIVEDIR}/${PKGNAME}-${VERSION}/${PKGNAME}-${VERSION}${PKGPREFIX}.zip
	@rm ${RELEASE}/zip.zip

clean:
	@echo "Cleaning work directorys"
	@rm -rf ${TEMP} ${RELEASE}

cvsclean:
	@echo "Cleaning CVS tags"
	@for p in `find .|grep CVS`; do rm -rf $${p}; done

BUILDMAKER=${BUILDDIR}/makesampleini.pl \
			${BUILDDIR}/Jcode-convert.pl \
			${BUILDDIR}/lang.pl \
			${BUILDDIR}/getversion.pl \
			${BUILDDIR}/build.mk \
			${BUILDDIR}/build.pl \
			${BUILDDIR}/compactmagic.pl

BUILDFILES=sample/pyukiwiki.ini.cgi \
			skin/common.en.js skin/common.ja.js \
			sample/common.sjis.ja.js sample/common.utf8.ja.js \
			lib/File/magic.txt lib/File/magic_compact.txt
#			skin/pyukiwiki.default.en.css skin/pyukiwiki.default.ja.css \
#			skin/pyukiwiki.print.en.css skin/pyukiwiki.print.ja.css \
#			skin/pyukiwiki.skin.en.cgi skin/pyukiwiki.skin.ja.cgi \

prof:FORCE
	@${PERL} -d:DProf index.cgi >/dev/null 2>/dev/null
	@dprofpp -O 30
	@rm tmon.out

build:FORCE ${BUILDFILES} ${BUILDMAKER}

FORCE:

lib/File/magic.txt: lib/File/magic.txt.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compactmagic.pl lib/File/magic.txt.src>lib/File/magic.txt

lib/File/magic_compact.txt: lib/File/magic.txt.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compactmagic.pl lib/File/magic.txt.src compact>lib/File/magic_compact.txt

sample/common.sjis.ja.js: skin/common.ja.js ${BUILDMAKER}
	${PERL} ${BUILDDIR}/Jcode-convert.pl sjis skin/common.ja.js sample/common.sjis.ja.js

sample/common.utf8.ja.js: skin/common.ja.js ${BUILDMAKER}
	${PERL} ${BUILDDIR}/Jcode-convert.pl utf8 skin/common.ja.js sample/common.utf8.ja.js

sample/pyukiwiki.ini.cgi: pyukiwiki.ini.cgi ${BUILDMAKER}
	${PERL} ${BUILDDIR}/makesampleini.pl > sample/pyukiwiki.ini.cgi

skin/common.en.js: skin/common.lang.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/lang.pl en skin/common.lang.js.src

skin/common.ja.js: skin/common.lang.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/lang.pl ja skin/common.lang.js.src

skin/pyukiwiki.default.en.css: skin/pyukiwiki.default.lang.css.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/lang.pl en skin/pyukiwiki.default.lang.css.src

skin/pyukiwiki.default.ja.css: skin/pyukiwiki.default.lang.css.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/lang.pl ja skin/pyukiwiki.default.lang.css.src

skin/pyukiwiki.print.en.css: skin/pyukiwiki.print.lang.css.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/lang.pl en skin/pyukiwiki.print.lang.css.src

skin/pyukiwiki.print.ja.css: skin/pyukiwiki.print.lang.css.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/lang.pl ja skin/pyukiwiki.print.lang.css.src

skin/pyukiwiki.skin.en.cgi: skin/pyukiwiki.skin.lang.cgi.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/lang.pl en skin/pyukiwiki.skin.lang.cgi.src

skin/pyukiwiki.skin.ja.cgi: skin/pyukiwiki.skin.lang.cgi.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/lang.pl ja skin/pyukiwiki.skin.lang.cgi.src
