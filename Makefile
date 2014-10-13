# release file makefile for pyukiwiki
# $Id: Makefile,v 1.34 2006/03/04 13:12:52 papu Exp $

ARCHIVEDIR=./archive
BUILDDIR=./build
CVSDIR=../CVS
CVSNAME="PyukiWiki-Devel"
TEMP=./temp
RELEASE=./release

SH?=/usr/local/bin/bash
#SH?=/bin/sh
CVS?=cvs
PERL=perl

ZIP="zip -9 -r"
TAR="tar cvf"
GZIP="gzip -9"

# vv use this...
GZIP_7Z="7za a -tgzip -mx9"
ZIP_7Z="7za a -tzip -mx9"
#GZIP_7Z="7za a -tgzip"
#ZIP_7Z="7za a -tzip"

PKGNAME=pyukiwiki

all:
	@${MAKE} all VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR} CVSDIR=${CVSDIR} \
		CVSNAME=${CVSNAME} TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		CVS=${CVS} PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} ZIP_7Z=${ZIP_7Z}

clean:
	@${MAKE} clean VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} PERL=${PERL}

build:FORCE
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}

buildrelease:FORCE
	@${MAKE} buildrelease VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR} \
		CVSNAME=${CVSNAME} TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME}


prof:FORCE
	@${MAKE} prof VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}

version:FORCE
	@${MAKE} version VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}

FORCE:

pkg:
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}
	@${MAKE} pkg VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR} CVSDIR=${CVSDIR} \
		CVSNAME=${CVSNAME} TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		CVS=${CVS} PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} ZIP_7Z=${ZIP_7Z}

cvscheckout:
	@${MAKE} checkout VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR} CVSDIR=${CVSDIR} \
		CVSNAME=${CVSNAME} TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		CVS=${CVS} PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} ZIP_7Z=${ZIP_7Z}

test:FORCE
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}
	@${MAKE} test VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR} CVSDIR=${CVSDIR} \
		CVSNAME=${CVSNAME} TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		CVS=${CVS} PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} ZIP_7Z=${ZIP_7Z}

cvsupdate:
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}
	@${MAKE} cvsupdate VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR} CVSDIR=${CVSDIR} \
		CVSNAME=${CVSNAME} TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		CVS=${CVS} PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} ZIP_7Z=${ZIP_7Z}

cvsoverride:
	@${MAKE} build VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk PERL=${PERL} BUILDDIR=${BUILDDIR}
	@${MAKE} cvsoverride VERSION=`${PERL} ${BUILDDIR}/getversion.pl` -f ${BUILDDIR}/build.mk \
		ARCHIVEDIR=${ARCHIVEDIR} BUILDDIR=${BUILDDIR} CVSDIR=${CVSDIR} \
		CVSNAME=${CVSNAME} TEMP=${TEMP} RELEASE=${RELEASE} SH=${SH} PKGNAME=${PKGNAME} \
		CVS=${CVS} PERL=${PERL} ZIP=${ZIP} TAR=${TAR} GZIP=${GZIP} \
		GZIP_7Z=${GZIP_7Z} ZIP_7Z=${ZIP_7Z}

