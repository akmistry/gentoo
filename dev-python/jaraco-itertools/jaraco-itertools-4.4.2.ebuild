# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Tests fail with PyPy and PyPy 3
PYTHON_COMPAT=( python{2_7,3_{5,6,7}} )

inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Tools for working with iterables. Complements itertools and more_itertools"
HOMEPAGE="https://github.com/jaraco/jaraco.itertools"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="doc test"

RDEPEND="
	>=dev-python/namespace-jaraco-2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/inflect[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-4.0.0[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/jaraco-packaging-3.2[${PYTHON_USEDEP}]
		>=dev-python/rst-linker-1.9[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_PN}-${PV}"

python_compile_all() {
	if use doc; then
		sphinx-build docs docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	# Override pytest options to skip flake8
	PYTHONPATH=. pytest -vv --override-ini="addopts=--doctest-modules" \
		|| die "tests failed with ${EPYTHON}"
}

# https://wiki.gentoo.org/wiki/Project:Python/Namespace_packages#File_collisions_between_pkgutil-style_packages
python_install() {
	rm "${BUILD_DIR}"/lib/jaraco/__init__.py || die
	# note: eclass may default to --skip-build in the future
	distutils-r1_python_install --skip-build
}
