# New ports collection makefile for:	testlink
# Date created:		2010-12-26
# Whom:			TAKATSU Tomonari <tota@FreeBSD.org>
#
# $FreeBSD$
#

PORTNAME=	testlink
PORTVERSION=	1.9.0
CATEGORIES=	www
MASTER_SITES=	SF
MASTER_SITE_SUBDIR=	${PORTNAME}/TestLink%201.9/TestLink%20${PORTVERSION}

MAINTAINER=	tota@FreeBSD.org
COMMENT=	A web based test management and test execution system

USE_ZIP=	yes
USE_PHP=	gd iconv mbstring
WANT_PHP_WEB=	yes
NO_BUILD=	yes

LICENSE=	GPLv2
LICENSE_FILE=	${WRKSRC}/LICENSE

PORTDOCS=	*
PORTEXAMPLES=	*

post-extract:
.for f in CHANGELOG CODE_REUSE README TL-1.9-Prague-NEWS.txt
	@${MV} ${WRKSRC}/${f} ${WRKSRC}/docs
.endfor
	@${MV} ${WRKSRC}/docs/db_sample ${WRKDIR}
	@${MV} ${WRKSRC}/docs/file_examples ${WRKDIR}
	@${MV} ${WRKSRC}/docs ${WRKDIR}
	@${FIND} ${WRKSRC} -name "\.*" -delete

do-install:
	@${MKDIR} ${WWWDIR}
	@cd ${WRKSRC} && ${COPYTREE_SHARE} . ${WWWDIR}
	@${CHOWN} -R ${WWWOWN}:${WWWGRP} ${WWWDIR}
.if !defined(NOPORTDOCS)
	@${MKDIR} ${DOCSDIR}
	@cd ${WRKDIR}/docs && ${COPYTREE_SHARE} . ${DOCSDIR}
	@${LN} -s ${DOCSDIR} ${WWWDIR}/docs
.endif
.if !defined(NOPORTEXAMPLES)
	@${MKDIR} ${EXAMPLESDIR}
	@cd ${WRKDIR} && ${COPYTREE_SHARE} db_sample ${EXAMPLESDIR}
	@cd ${WRKDIR} && ${COPYTREE_SHARE} file_examples ${EXAMPLESDIR}
.endif

post-install:
	@${RM} ${WWWDIR}/LICENSE

x-generate-plist:
	${FIND} ${WWWDIR} -type f | ${SORT} | ${SED} -e 's,${WWWDIR},%%WWWDIR%%,g' >> pkg-plist.new
	${FIND} ${WWWDIR} -type d -depth | ${SORT} -r | ${SED} -e 's,${WWWDIR},@dirrm %%WWWDIR%%,g' >> pkg-plist.new
	${ECHO} '@exec chown -R %%WWWOWN%%:%%WWWGRP%% %%WWWDIR%%' >> pkg-plist.new

.include <bsd.port.mk>
