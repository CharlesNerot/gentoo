# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.savannah.gnu.org/${PN}.git
		http://git.savannah.gnu.org/r/${PN}.git"
	# We need all the tags in order to figure out the right version.
	# The git-r3 eclass doesn't support that, so have to stick to 2.
	inherit git-r3
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.xz
		ftp://alpha.gnu.org/pub/gnu/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

inherit toolchain-autoconf

DESCRIPTION="Used to create autoconfiguration files"
HOMEPAGE="https://www.gnu.org/software/autoconf/autoconf.html"

LICENSE="GPL-3"
SLOT="${PV}"
IUSE="emacs"

DEPEND=">=sys-devel/m4-1.4.16
	>=dev-lang/perl-5.6"
RDEPEND="${DEPEND}
	!~sys-devel/${P}:2.5
	>=sys-devel/autoconf-wrapper-13"
[[ ${PV} == "9999" ]] && DEPEND+=" >=sys-apps/texinfo-4.3"
PDEPEND="emacs? ( app-emacs/autoconf-mode )"

src_prepare()   {
	# usr/bin/libtool is provided by binutils-apple, need gnu libtool
	[[ ${CHOST} == *-darwin* ]] && \
		PATCHES+=( "${FILESDIR}"/${PN}-2.61-darwin.patch )
	PATCHES+=(
		"${FILESDIR}"/${PN}-2.69-perl-5.26.patch
		"${FILESDIR}"/${P}-fix-libtool-test.patch
		"${FILESDIR}"/${PN}-2.69-perl-5.26-2.patch
	)
	toolchain-autoconf_src_prepare
	eapply_user
}
