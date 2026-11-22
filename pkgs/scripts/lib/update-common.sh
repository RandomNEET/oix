#!/usr/bin/env bash

# Parse shared updater options
update_parse_args() {
	UPDATE_COMMIT=0
	UPDATE_TARGET=''
	local positional=0
	while (($#)); do
		case "$1" in
		--commit) UPDATE_COMMIT=1 ;;
		--)
			shift
			(($# <= 1 && positional == 0)) || fail 'Expected at most one target file'
			if (($#)); then UPDATE_TARGET=$1; fi
			break
			;;
		-*) fail "Unknown option: $1" ;;
		*)
			((positional == 0)) || fail 'Expected at most one target file'
			UPDATE_TARGET=$1
			positional=1
			;;
		esac
		shift
	done
}

# Require clean tracked targets before committing
update_check_commit() {
	((UPDATE_COMMIT)) || return 0
	command -v git >/dev/null || fail 'Required command not found: git'
	local file root
	root=$(git -C "$TARGET_DIR" rev-parse --show-toplevel) || fail 'Target is not in a Git repository'
	for file in "$@"; do
		[[ $file == "$root/"* ]] || fail "Target is outside the Git repository: $file"
		git -C "$root" --literal-pathspecs ls-files --error-unmatch -- "$file" >/dev/null 2>&1 ||
			fail "Target is not tracked by Git: $file"
		[[ -z $(git -C "$root" --literal-pathspecs status --porcelain -- "$file") ]] ||
			fail "Target has uncommitted changes: $file"
	done
}

update_git_commit() {
	((UPDATE_COMMIT)) || return 0
	local package=$1 old=$2 new=$3
	shift 3
	local message="$package: $old -> $new"
	if [[ $old == "$new" ]]; then message="$package: update sources"; fi
	git -C "$TARGET_DIR" --literal-pathspecs commit --only \
		-m "$message" -- "$@" ||
		fail 'Git commit failed; updated files have been retained'
}

update_sources_version() {
	jq -r '[.[].version] | unique | sort_by(split(".") | map(tonumber)) | join(", ")' "$1"
}
