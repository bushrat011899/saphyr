# saphyr

[saphyr](https://github.com/saphyr-rs/saphyr) is a fully compliant YAML 1.2
library written in pure Rust.

This work is based on [`yaml-rust`](https://github.com/chyh1990/yaml-rust) with
fixes towards being compliant to the [YAML test
suite](https://github.com/yaml/yaml-test-suite/). `yaml-rust`'s parser is
heavily influenced by `libyaml` and `yaml-cpp`.

`saphyr` is a pure Rust YAML 1.2 implementation that benefits from the
memory safety and other benefits from the Rust language.

## Quick Start
### Installing
Add the following to your Cargo.toml:

```toml
[dependencies]
saphyr = "0.0.1"
```
or use `cargo add` to get the latest version automatically:
```sh
cargo add saphyr
```

### Example
Use `saphyr::YamlLoader` to load YAML documents and access them as `Yaml` objects:

```rust
use saphyr::{Yaml, YamlEmitter};

fn main() {
    let s =
"
foo:
    - list1
    - list2
bar:
    - 1
    - 2.0
";
    let docs = Yaml::load_from_str(s).unwrap();

    // Multi document support, doc is a yaml::Yaml
    let doc = &docs[0];

    // Debug support
    println!("{:?}", doc);

    // Index access for map & array
    assert_eq!(doc["foo"][0].as_str().unwrap(), "list1");
    assert_eq!(doc["bar"][1].as_f64().unwrap(), 2.0);

    // Array/map-like accesses are checked and won't panic.
    // They will return `BadValue` if the access is invalid.
    assert!(doc["INVALID_KEY"][100].is_badvalue());

    // Dump the YAML object
    let mut out_str = String::new();
    {
        let mut emitter = YamlEmitter::new(&mut out_str);
        emitter.dump(doc).unwrap(); // dump the YAML object to a String
    }
    println!("{}", out_str);
}
```

Note that `saphyr::Yaml` implements `Index<&'a str>` and `Index<usize>`:

* `Index<usize>` assumes the container is an array
* `Index<&'a str>` assumes the container is a string to value map
* otherwise, `Yaml::BadValue` is returned

Note that `annotated::YamlData` cannot return `BadValue` and will panic.

If your document does not conform to this convention (e.g. map with complex
type key), you can use the `Yaml::as_XXX` family API of functions to access
your objects.

## Features

* Pure Rust
* `Vec`/`HashMap` access API

## Security

This library does not try to interpret any type specifiers in a YAML document,
so there is no risk of, say, instantiating a socket with fields and
communicating with the outside world just by parsing a YAML document.

## Specification Compliance

This implementation is fully compatible with the YAML 1.2 specification. The
parser behind this library
([`saphyr-parser`](https://github.com/saphyr-rs/saphyr-parser)) tests against
(and passes) the [YAML test suite](https://github.com/yaml/yaml-test-suite/).

## License

Licensed under either of

 * Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0)
 * MIT license (http://opensource.org/licenses/MIT)

at your option.

Since this repository was originally maintained by
[chyh1990](https://github.com/chyh1990), there are 2 sets of licenses.
A license of each set must be included in redistributions. See the
[LICENSE](LICENSE) file for more details.

You can find licences in the [`.licenses`](.licenses) subfolder.

## Contribution

[Fork this repository](https://github.com/saphyr-rs/saphyr/fork) and
[Create a Pull Request on Github](https://github.com/saphyr-rs/saphyr/compare/master...saphyr-rs:saphyr:master).
You may need to click on "compare across forks" and select your fork's branch.

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in the work by you, as defined in the Apache-2.0 license, shall
be dual licensed as above, without any additional terms or conditions.

## Links

* [saphyr source code repository](https://github.com/saphyr-rs/saphyr)

* [saphyr releases on crates.io](https://crates.io/crates/saphyr)

* [saphyr documentation on docs.rs](https://docs.rs/saphyr/latest/saphyr/)

* [saphyr-parser releases on crates.io](https://crates.io/crates/saphyr-parser)

* [yaml-test-suite](https://github.com/yaml/yaml-test-suite)
