# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )
inherit python-any-r1 cmake-utils virtualx

DESCRIPTION="Qt bindings for the Telepathy D-Bus protocol"
HOMEPAGE="https://telepathy.freedesktop.org/"
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="debug farstream test"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
	farstream? (
		>=net-libs/telepathy-farstream-0.2.2
		>=net-libs/telepathy-glib-0.18.0
	)
"
DEPEND="${RDEPEND}
	test? (
		dev-libs/dbus-glib
		dev-qt/qttest:5
	)
"
BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig
	test? (
		dev-libs/glib:2
		$(python_gen_any_dep '
			dev-python/dbus-python[${PYTHON_USEDEP}]
		')
	)
"
RESTRICT="!test? ( test )"

python_check_deps() {
	has_version "dev-python/dbus-python[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DEBUG_OUTPUT=$(usex debug)
		-DENABLE_FARSTREAM=$(usex farstream)
		-DENABLE_TESTS=$(usex test)
		-DENABLE_EXAMPLES=OFF
	)
	cmake-utils_src_configure
}

src_test() {
	# some tests require D-Bus
	local myctestargs=(
		-E "(BaseConnectionManager|BaseProtocol)"
	)
	pushd "${BUILD_DIR}" > /dev/null || die
	virtx cmake-utils_src_test
	popd > /dev/null || die
}
