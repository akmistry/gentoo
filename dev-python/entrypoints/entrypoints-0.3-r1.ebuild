# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy{,3} python{2_7,3_{5,6,7,8}} )

inherit distutils-r1

DESCRIPTION="Discover and load entry points from installed packages"
HOMEPAGE="https://github.com/takluyver/entrypoints"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~sparc ~x86"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/configparser-3.5.0[${PYTHON_USEDEP}]' 'python2*')
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		virtual/python-pathlib[${PYTHON_USEDEP}]
	)
"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}"-0.2.1-init.py.patch
)

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	cp -r "${S}"/tests "${TEST_DIR}"/lib/ || die
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
