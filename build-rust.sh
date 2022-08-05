#!/usr/bin/env bash
#
# This script builds the Rust crate in its directory into a staticlib XCFramework for iOS.

BUILD_PROFILE="release"
FRAMEWORK_NAME="JunoRust"

WORKING_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TARGET_DIR="$WORKING_DIR/target"
GENERATED_DIR="$WORKING_DIR/generated"
HEADERS_DIR=${GENERATED_DIR}/headers
SWIFT_DIR="${WORKING_DIR}/Sources/${FRAMEWORK_NAME}"

CARGO="$HOME/.cargo/bin/cargo"
MANIFEST_PATH="$WORKING_DIR/Cargo.toml"
FRAMEWORK_FILENAME="$GENERATED_DIR/${FRAMEWORK_NAME}FFI.xcframework"

echo "BUILD_PROFILE: $BUILD_PROFILE"
echo "FRAMEWORK_NAME: $FRAMEWORK_NAME"

echo "WORKING_DIR: $WORKING_DIR"
echo "TARGET_DIR: $TARGET_DIR"
echo "GENERATED_DIR: $GENERATED_DIR"
echo "HEADERS_DIR: $HEADERS_DIR"
echo "SWIFT_DIR: $SWIFT_DIR"

echo "CARGO: $CARGO"
echo "MANIFEST_PATH: $MANIFEST_PATH"

if [[ ! -f "$MANIFEST_PATH" ]]; then
  echo "Could not locate Cargo.toml in $MANIFEST_PATH"
  exit 1
fi

CRATE_NAME=$(grep --max-count=1 '^name =' "$MANIFEST_PATH" | cut -d '"' -f 2)
if [[ -z "$CRATE_NAME" ]]; then
  echo "Could not determine crate name from $MANIFEST_PATH"
  exit 1
else
  echo "Processing Crate name: $CRATE_NAME"
fi

LIB_NAME="lib${CRATE_NAME}.a"
LIB_NAME_IOS="$GENERATED_DIR/lib${CRATE_NAME}_ios.a"
LIB_NAME_IOS_SIM="$GENERATED_DIR/lib${CRATE_NAME}_iossimulator.a"
LIB_NAME_MAC="$GENERATED_DIR/lib${CRATE_NAME}_macos.a"
echo "LIB_NAME: $LIB_NAME"

####
##
## 1) Build the rust code individually for each target architecture.
##
####

# Helper to run the cargo build command in a controlled environment.
# It's important that we don't let environment variables from the user's default
# desktop build environment leak into the iOS build, otherwise it might e.g.
# link against the desktop build of NSS.

DEFAULT_RUSTFLAGS=""
BUILD_ARGS=(build --manifest-path "$MANIFEST_PATH" --lib)
case $BUILD_PROFILE in
  debug) ;;
  release)
    BUILD_ARGS=("${BUILD_ARGS[@]}" --release)
    # With debuginfo, the zipped artifact quickly baloons to many
    # hundred megabytes in size. Ideally we'd find a way to keep
    # the debug info but in a separate artifact.
    DEFAULT_RUSTFLAGS="-C debuginfo=0"
    ;;
  *) echo "Unknown build profile: $BUILD_PROFILE"; exit 1;
esac
echo "Build Args: ${BUILD_ARGS[@]}"

cargo_build () {
  TARGET=$1
  env -i \
    PATH="${PATH}" \
    RUSTC_WRAPPER="${RUSTC_WRAPPER:-}" \
    RUST_LOG="${RUST_LOG:-}" \
    RUSTFLAGS="${RUSTFLAGS:-$DEFAULT_RUSTFLAGS}" \
    "$CARGO" "${BUILD_ARGS[@]}" --target "$TARGET"
}

# set -euvx

# Hardware iOS targets
cargo_build aarch64-apple-ios
echo "Processed iOS Device."

# M1 iOS simulator.
cargo_build aarch64-apple-ios-sim
echo "Processed M1 iOS simulator."

# Intel iOS simulator
cargo_build x86_64-apple-ios
echo "Processed Intel iOS simulator."

# M1 Mac
cargo_build aarch64-apple-darwin
echo "Processed M1 Mac."

# Intel Mac
cargo_build x86_64-apple-darwin
echo "Processed Intel Mac."

###
#
# 2) Stitch the individual builds together an XCFramework bundle.
#
###

rm -rf $GENERATED_DIR
mkdir -p $GENERATED_DIR

cp "$TARGET_DIR/aarch64-apple-ios/$BUILD_PROFILE/$LIB_NAME" "$LIB_NAME_IOS"

lipo -create \
  -output "$LIB_NAME_IOS_SIM" \
  "$TARGET_DIR/aarch64-apple-ios-sim/$BUILD_PROFILE/$LIB_NAME" \
  "$TARGET_DIR/x86_64-apple-ios/$BUILD_PROFILE/$LIB_NAME"

lipo -create \
  -output "$LIB_NAME_MAC" \
  "$TARGET_DIR/aarch64-apple-darwin/$BUILD_PROFILE/$LIB_NAME" \
  "$TARGET_DIR/x86_64-apple-darwin/$BUILD_PROFILE/$LIB_NAME"

uniffi-bindgen generate "$WORKING_DIR/src/junorust.udl" --no-format --language swift --out-dir ${GENERATED_DIR}

# Move them to the right place
mkdir -p ${HEADERS_DIR}
mkdir -p ${SWIFT_DIR}

mv ${GENERATED_DIR}/*.h ${HEADERS_DIR}
mv ${GENERATED_DIR}/*.swift ${SWIFT_DIR}
# Rename and move modulemap to the right place
mv ${GENERATED_DIR}/*.modulemap ${HEADERS_DIR}/module.modulemap

# Build the xcframework

if [ -d "$FRAMEWORK_FILENAME" ]; then rm -rf "$FRAMEWORK_FILENAME"; fi

xcodebuild -create-xcframework \
  -library "$LIB_NAME_IOS" \
  -headers ${HEADERS_DIR} \
  -library "$LIB_NAME_IOS_SIM" \
  -headers ${HEADERS_DIR} \
  -library "$LIB_NAME_MAC" \
  -headers ${HEADERS_DIR} \
  -output "$FRAMEWORK_FILENAME"
