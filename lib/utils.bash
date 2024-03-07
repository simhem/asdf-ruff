#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/astral-sh/ruff"
TOOL_NAME="ruff"
TOOL_TEST="ruff --help"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if ruff is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# Change this function if ruff has other means of determining installable versions.
	list_github_tags
}

get_os() {
	case "$OSTYPE" in
	darwin*) 
		echo "apple-darwin" 
		;;
	linux*)   
		echo "unknown-linux-gnu"
		;;
	msys*)    
		echo "pc-windows-msvc" 
		;;
	cygwin*)  
		echo "pc-windows-msvc" 
		;;
	*)        
		echo "OS type is not supported"
		exit 1 
		;;
    esac
}

get_ext() {
	case "$OSTYPE" in
	darwin*) 
		echo "tar.gz" 
		;;
	linux*)   
		echo "tar.gz" 
		;;
	msys*)    
		echo "zip" 
		;;
	cygwin*)  
		echo "zip" 
		;;
	*)        
		echo "OS type is not supported"
		exit 1 
		;;
    esac
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	architecture="$(arch)"
	os=$(get_os)
	ext=$(get_ext)

	url="$GH_REPO/releases//download/v${version}/$TOOL_NAME-${version}-${architecture}-${os}.${ext}"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		echo $install_path

		# Assert ruff executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
