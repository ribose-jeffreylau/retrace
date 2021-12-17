#!/bin/sh
set -ex

# https://gist.github.com/marcusandre/4b88c2428220ea255b83
get_os() {
	if [ -z "$OSTYPE" ]; then
		uname
	else
		echo "$OSTYPE"
	fi | tr '[:upper:]' '[:lower:]'
}

macos_install() {
	brew update
	packages="
		openssl
		make
		cmake
		autoconf
		automake
		libtool
		cmocka
		pkg-config
		ruby
	"
	for p in ${packages}; do
		brew install "${p}" || brew upgrade "${p}"
	done
	mkdir -p "${CMOCKA_INSTALL}"
	gem install mustache
}

freebsd_install() {
	sudo pkg install -y cmake
	sudo pkg install -y ruby
	sudo pkg install -y devel/ruby-gems
	sudo pkg install -y bash
	sudo pkg install -y git
	sudo pkg install -y wget
	sudo pkg install -y autoconf
	sudo pkg install -y automake
	sudo pkg install -y libtool
	sudo pkg install -y pkgconf
	sudo gem install mustache
}

openbsd_install() {
	echo ""
}

netbsd_install() {
	echo ""
}

linux_install() {
	sudo gem install mustache
}

crossplat_install() {
	echo ""
}

main() {
	echo CMOCKA_INSTALL="${HOME}/builds/cmocka-install" >> "${GITHUB_ENV}"
	echo CHECKPATCH_INSTALL="${HOME}/builds/checkpatch-install" >> "${GITHUB_ENV}"
	case $(get_os) in
		freebsd*)
			freebsd_install ;;
		netbsd*)
			netbsd_install ;;
		openbsd*)
			openbsd_install ;;
		darwin*)
			macos_install ;;
		linux*)
			linux_install ;;
		*) echo "unknown"; exit 1 ;;
	esac

	crossplat_install
}

main
