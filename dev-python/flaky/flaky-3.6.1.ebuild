# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7,8} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Plugin for nose or py.test that automatically reruns flaky tests"
HOMEPAGE="https://pypi.org/project/flaky/ https://github.com/box/flaky"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/genty[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
python_test() {
	nosetests --with-flaky --exclude="test_nose_options_example" test/test_nose/ || die
	pytest -k 'example and not options' --doctest-modules test/test_pytest/ || die
	pytest -p no:flaky test/test_pytest/test_flaky_pytest_plugin.py || die
	nosetests --with-flaky --force-flaky --max-runs 2 test/test_nose/test_nose_options_example.py || die
	pytest --force-flaky --max-runs 2  test/test_pytest/test_pytest_options_example.py || die
}
