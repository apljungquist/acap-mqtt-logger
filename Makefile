## Configuration
## =============

# Parameters
# ----------

# Name of package containing the app to be built.
# Rust does not enforce that the path to the package matches the package name, but
# this makefile does to keep things simple.
# Keep in sync with both
# - `acapPackageConf.setup.appName` in `manifest.json`
# - `package.name` in `Cargo.toml`
export AXIS_PACKAGE ?= tiny_app

# The architecture that will be assumed when interacting with the device.
export AXIS_DEVICE_ARCH ?= aarch64

# The IP address of the device to interact with.
export AXIS_DEVICE_IP ?= 192.168.0.90

# The username to use when interacting with the device.
export AXIS_DEVICE_USER ?= root

# The password to use when interacting with the device.
export AXIS_DEVICE_PASS ?= pass

# Other
# -----

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
check_all: check_build check_docs check_format check_lint
.PHONY: check_all

## Check that all crates can be built
check_build:
	cargo-acap-build --target aarch64
.PHONY: check_build

## Check that docs can be built
check_docs:
	RUSTDOCFLAGS="-Dwarnings" cargo doc \
		--document-private-items \
		--no-deps \
		--target aarch64-unknown-linux-gnu \
		--workspace
.PHONY: check_docs

## Check that the code is formatted correctly
check_format:
	cargo fmt --check
.PHONY: check_format

## Check that the code is free of lints
check_lint:
	cargo clippy \
		--all-targets \
		--no-deps \
		--target aarch64-unknown-linux-gnu \
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
	cargo clippy --fix
.PHONY: fix_lint


## Nouns
## =====

sizes.txt:
	for t in aarch64-unknown-linux-gnu thumbv7neon-unknown-linux-gnueabihf; do \
		CARGO_PROFILE_RELEASE_OPT_LEVEL="s" \
		CARGO_PROFILE_RELEASE_STRIP="symbols" \
		CARGO_PROFILE_RELEASE_LTO="true" \
		CARGO_PROFILE_RELEASE_PANIC="abort" \
		CARGO_PROFILE_RELEASE_CODEGEN_UNITS="1" \
		RUSTFLAGS="-Zlocation-detail=none -Zfmt-debug=none" \
		cargo +nightly build \
			--target=$$t \
			--release -Zbuild-std=panic_abort,std \
			-Zbuild-std-features=panic_immediate_abort,optimize_for_size; \
	done
	du \
		--apparent-size \
		--human-readable \
		--total \
		target/aarch64-unknown-linux-gnu/release/tiny_app \
		target/thumbv7neon-unknown-linux-gnueabihf/release/tiny_app \
	> $@

.PHONY: sizes.txt
