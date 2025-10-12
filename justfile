before_commit:
  cargo fmt --check
  cargo clippy --release --all-targets -- -D warnings
  cargo clippy --all-targets -- -D warnings
  cargo build --release --all-targets
  cargo build --all-targets
  cargo test
  cargo test --release
  cargo test --doc
  cargo build --release --package gen_large_yaml --bin gen_large_yaml --manifest-path bench/tools/gen_large_yaml/Cargo.toml
  cargo build --release --package bench_compare --bin bench_compare --manifest-path bench/tools/bench_compare/Cargo.toml
  cargo build --release --package walk --bin walk --manifest-path parser/tools/walk/Cargo.toml
  just check_doc
  just check_no_std

check_doc:
  RUSTDOCFLAGS="-D warnings" cargo doc --all-features --document-private-items

fuzz:
  CARGO_PROFILE_RELEASE_LTO=false cargo +nightly fuzz run parse

# You may need to add the wasm32v1-none target using:
# rustup target add wasm32v1-none
# Checks for no_std compatibility using wasm32v1-none
check_no_std:
  cargo check -p saphyr --no-default-features --target wasm32v1-none