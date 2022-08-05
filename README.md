# Juno

A Datastore for Apple platforms.

## Instructions

### For development
1. Setup rust using [rustup](https://rustup.rs)
2. Install [Uniffi](https://github.com/mozilla/uniffi-rs) bindgen tool using - `cargo install --version 0.19.3 uniffi-bindgen`
3. Run `bash build-rust.rs`. This should generate binary JunoRustFFI.xcframework in generated folder which Swift library `JunoRustFFI` will become. Also `Sources/JunoRust/*.swift` which will create wrapper around JunoRustFFI binary library for easy use.
4. Run swift unit tests in Tests to check everything is properly working.
