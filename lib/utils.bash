#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/XAMPPRocky/tokei"
TOOL_NAME="tokei"
TOOL_TEST="tokei --version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -V | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//'
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version filename url assetprefix assetplatform assetname
  version="$1"
  filename="$2"

  if verlt "$version" "11.0.0"; then
    assetprefix="tokei-v${version}-"
  else
    assetprefix="tokei-"
  fi

  case "$(uname -s)" in
  "Darwin")
    case "$(uname -m)" in
    "x86_64")
      assetplatform="x86_64-apple-darwin"
      ;;
    "arm64")
      assetplatform="arm64-apple-darwin"
      ;;
    esac
    ;;
  "Linux")
    case "$(uname -m)" in
    "x86_64")
      assetplatform="x86_64-unknown-linux-musl"
      ;;
    "i686")
      assetplatform="i686-unknown-linux-musl"
      ;;
    "armv7l")
      assetplatform="armv7-unknown-linux-gnueabihf"
      ;;
    "aarch64")
      assetplatform="aarch64-unknown-linux-gnu"
      ;;
    esac
    ;;
  esac
  assetname="${assetprefix}${assetplatform}"
  url="$GH_REPO/releases/download/v${version}/${assetname}.tar.gz"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path/bin"
    cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path/bin"

    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}

verlte() {
  [ "$1" = "$(echo -e "$1\n$2" | sort -V | head -n1)" ]
}

verlt() {
  [ "$1" = "$2" ] && return 1 || verlte $1 $2
}
