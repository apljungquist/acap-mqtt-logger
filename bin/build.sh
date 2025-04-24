#!/usr/bin/env sh
set -ux

# Beware of feature unification

PACKAGE=$1
TARGET=$2
PRESET=$3

ARTIFACT_DIR="artifacts/${TARGET}/${PRESET}"
export CARGO_TARGET_DIR="targets/${TARGET}/${PRESET}"

# Location detail is separate from trim-paths https://rust-lang.github.io/rfcs/3127-trim-paths.html

case $PRESET in
  stable-debug)
    cargo +nightly build -Zunstable-options --artifact-dir=${ARTIFACT_DIR} --package=${PACKAGE} --target=${TARGET}
    ;;
  stable-release)
    cargo +nightly build -Zunstable-options --artifact-dir=${ARTIFACT_DIR} --package=${PACKAGE} --target=${TARGET} --release
    ;;
  stable-lossless)
    CARGO_PROFILE_RELEASE_OPT_LEVEL="s" CARGO_PROFILE_RELEASE_LTO="true" CARGO_PROFILE_RELEASE_CODEGEN_UNITS="1" \
    cargo +nightly build -Zunstable-options --artifact-dir=${ARTIFACT_DIR} --package=${PACKAGE} --target=${TARGET} --release
    ;;
  stable-abort)
    CARGO_PROFILE_RELEASE_OPT_LEVEL="s" CARGO_PROFILE_RELEASE_LTO="true" CARGO_PROFILE_RELEASE_CODEGEN_UNITS="1" CARGO_PROFILE_RELEASE_PANIC="abort" \
    cargo +nightly build -Zunstable-options --artifact-dir=${ARTIFACT_DIR} --package=${PACKAGE} --target=${TARGET} --release
    ;;
  stable-max)
    CARGO_PROFILE_RELEASE_OPT_LEVEL="s" CARGO_PROFILE_RELEASE_LTO="true" CARGO_PROFILE_RELEASE_CODEGEN_UNITS="1" CARGO_PROFILE_RELEASE_PANIC="abort" CARGO_PROFILE_RELEASE_STRIP="symbols" \
    cargo +nightly build -Zunstable-options --artifact-dir=${ARTIFACT_DIR} --package=${PACKAGE} --target=${TARGET} --release
    ;;
  unstable-lossless)
    CARGO_PROFILE_RELEASE_OPT_LEVEL="s" CARGO_PROFILE_RELEASE_LTO="true" CARGO_PROFILE_RELEASE_CODEGEN_UNITS="1" \
    cargo +nightly build -Zunstable-options --artifact-dir=${ARTIFACT_DIR} --package=${PACKAGE} --target=${TARGET} --release -Zbuild-std=std
    ;;
  unstable-abort)
    CARGO_PROFILE_RELEASE_OPT_LEVEL="s" CARGO_PROFILE_RELEASE_LTO="true" CARGO_PROFILE_RELEASE_CODEGEN_UNITS="1" CARGO_PROFILE_RELEASE_PANIC="abort" \
    cargo +nightly build -Zunstable-options --artifact-dir=${ARTIFACT_DIR} --package=${PACKAGE} --target=${TARGET} --release -Zbuild-std=panic_abort,std -Zbuild-std-features=panic_immediate_abort
    ;;
  unstable-max)
    RUSTFLAGS=" -Zlocation-detail=none -Zfmt-debug=none -Clink-args=-lc" \
    CARGO_PROFILE_RELEASE_OPT_LEVEL="s" CARGO_PROFILE_RELEASE_LTO="true" CARGO_PROFILE_RELEASE_CODEGEN_UNITS="1" CARGO_PROFILE_RELEASE_PANIC="abort" CARGO_PROFILE_RELEASE_STRIP="symbols" \
    cargo +nightly build -Zunstable-options --artifact-dir=${ARTIFACT_DIR} --package=${PACKAGE} --target=${TARGET} --release -Zbuild-std=panic_abort,std -Zbuild-std-features=panic_immediate_abort,optimize_for_size
    ;;
esac
