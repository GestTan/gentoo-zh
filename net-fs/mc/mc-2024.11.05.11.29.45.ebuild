# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

MY_PV="$(ver_cut 1-3)T$(ver_cut 4-7)Z"
MY_PV=${MY_PV//./-}
YEAR="$(ver_cut 1)"
EGIT_COMMIT=9f4659884dd45dca726ba38ee6bfacb2bf776eb8

DESCRIPTION="Minio client provides alternatives for ls, cat on cloud storage and filesystems"
HOMEPAGE="https://github.com/minio/mc"
SRC_URI="
	https://github.com/minio/mc/archive/RELEASE.${MY_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/peeweep/gentoo-go-deps/releases/download/${P}/${P}-deps.tar.xz
"

S="${WORKDIR}/${PN}-RELEASE.${MY_PV}"
LICENSE="Apache-2.0 BSD MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="!!app-misc/mc"

src_compile() {
	# go run buildscripts/gen-ldflags.go
	local ldflags="-s -w \
		-X github.com/minio/mc/cmd.Version=${MY_PV} \
		-X github.com/minio/mc/cmd.CopyrightYear=${YEAR} \
		-X github.com/minio/mc/cmd.ReleaseTag=RELEASE.${MY_PV} \
		-X github.com/minio/mc/cmd.CommitID=${EGIT_COMMIT}"
	ego build -trimpath --ldflags "${ldflags}"
}

src_install() {
	dobin mc
	dodoc README.md CONTRIBUTING.md
}