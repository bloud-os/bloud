#!/bin/sh

set -eu

REPO="d-buckner/bloud"

# The repository publishes immutable releases
api="https://api.github.com/repos/$REPO/releases?per_page=30"
if ! json="$(curl -fsSL -H 'Accept: application/vnd.github+json' "$api")"; then
	printf 'bloud: could not read the release list from %s.\n' "$REPO" >&2
	printf '       A 403 here means the anonymous limit was hit: 60 requests\n' >&2
	printf '       per hour per IP. Wait a while and retry.\n' >&2
	exit 1
fi

# The release list is newest first, so the first .deb asset is the current build
url="$(printf '%s' "$json" |
	tr ',' '\n' |
	sed -n 's/.*"browser_download_url"[[:space:]]*:[[:space:]]*"\([^"]*\.deb\)".*/\1/p' |
	head -n 1)"

if [ -z "$url" ]; then
	printf 'bloud: no published .deb found in %s\n' "$REPO" >&2
	printf '       Browse https://github.com/%s/releases by hand.\n' "$REPO" >&2
	exit 1
fi

# GitHub percent-encodes the "+" in the version in the URL; the asset name, and
# so the SHA256SUMS entry, uses the literal character.
asset="$(printf '%s' "${url##*/}" | sed 's/%2B/+/g')"
want=""
if sums="$(curl -fsSL "${url%/*}/SHA256SUMS")"; then
	want="$(printf '%s\n' "$sums" | awk -v n="$asset" '$2 == n { print $1; exit }')"
fi

# Test hook, used to assert that this resolver picks a real published release.
# Prints the URL and nothing else, and runs unprivileged.
if [ "${BLOUD_INSTALL_URL_ONLY:-}" = "1" ]; then
	printf '%s\n' "$url"
	exit 0
fi

[ "$(id -u)" -eq 0 ] || { echo "bloud: run this through sudo" >&2; exit 1; }

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT INT TERM

printf '==> Downloading %s\n' "$url"
curl -fsSL -o "$tmp/bloud.deb" "$url"

# A mismatch means the bytes we got are not the bytes the release lists: a
# truncated or corrupted download. This is not a security boundary. The
# checksum arrives from the same TLS origin as the file, so it cannot vouch for
# provenance, and the .deb is unsigned. If the release carries no checksum we
# carry on rather than block every install on a missing asset.
if [ "${#want}" -eq 64 ]; then
	if printf '%s  %s\n' "$want" "$tmp/bloud.deb" |
		sha256sum -c - >/dev/null 2>&1; then
		printf '==> Checksum verified\n'
	else
		printf 'bloud: the downloaded .deb does not match the published checksum.\n' >&2
		printf '       Expected %s\n' "$want" >&2
		printf '       Refusing to install it.\n' >&2
		exit 1
	fi
else
	printf '==> No published checksum to check against, skipping verification\n'
fi

printf '==> Installing (apt pulls podman, uidmap, and the rest)\n'
apt-get install -y "$tmp/bloud.deb"

printf '==> Done. The first run converges the system before the\n'
printf '    dashboard answers: give it a minute or two, then open http://%s\n' \
	"$(hostname -I 2>/dev/null | cut -d' ' -f1 || echo localhost)"
