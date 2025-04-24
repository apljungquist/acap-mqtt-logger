## Configuration
## =============

# Have zero effect by default to prevent accidental changes.
.DEFAULT_GOAL := none

# Delete targets that fail to prevent subsequent attempts incorrectly assuming
# the target is up to date.
.DELETE_ON_ERROR: ;

# Prevent pesky default rules from creating unexpected dependency graphs.
.SUFFIXES: ;


## Verbs
## =====

none:;

## Checks
## ------

## Run all other checks
check_all: check_build check_format check_lint
.PHONY: check_all

## Check that all crates can be built
check_build:
	CARGO_PROFILE_DEFAULT_PANIC="abort" \
	cargo build
.PHONY: check_build

## Check that the code is formatted correctly
check_format:
	cargo fmt --check
.PHONY: check_format

## Check that the code is free of lints
check_lint:
	CARGO_PROFILE_DEFAULT_PANIC="abort" \
	cargo clippy \
		--all-targets \
		--no-deps
		-- \
		-Dwarnings
.PHONY: check_lint

## Fixes
## -----

## Attempt to fix formatting automatically
fix_format:
	cargo fmt
.PHONY: fix_format

## Attempt to fix lints automatically
fix_lint:
	CARGO_PROFILE_DEFAULT_PANIC="abort" \
	cargo clippy --fix
.PHONY: fix_lint

## Nouns
## =====
