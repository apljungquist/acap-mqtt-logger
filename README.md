# Managing the size of Rust apps

A great summary of techniques that informed this work: https://github.com/johnthagen/min-sized-rust?tab=readme-ov-file

<!--
Previous work:

- 46318837614150e0c8709bce2651b23f40576f89
    - Sizes (`x86_64-unknown-linux-gnu`)
        - 7.7M artifacts/baseline/hello_world ()
        - 720K artifacts/release/hello_world
        - 420K artifacts/stable/hello_world
        - 116K artifacts/unstable/hello_world
        - 116K artifacts/unstable2/hello_world
        - 112K artifacts/unstable3/hello_world
        - 108K artifacts/unstable4/hello_world
- da6446e7ef056b38d8a301840760e2f97926441f

* Q: How can the size of apps be reduced?
    * Q: Effect of compilation options?
    * Q: Effect of dependencies?
        * Q: Efficient alternatives to common functions?
            * Q: In particular shared those using shared libraries?
            * Q: What common functions can we replace with glib, etc on no-std?
* Differences between armv7hf targets?
* Differences between targets?
* Are symbols even useful if panic=abort?
* Does building the standard library with `trim-paths` improve size?
    * Or https://doc.rust-lang.org/beta/unstable-book/compiler-flags/location-detail.html
* Evaluate `µfmt`

Optimizing rust binaries and libraries for size is different from optimizing them for ergonomics and speed.
Some good techniques are described in https://web.archive.org/web/20250108214641/https://dl.acm.org/doi/pdf/10.1145/3519941.3535075#expand
The big list items, panic data and formatting can probably be addressed with unstable compiler options:
`fmt-debug=none` and `build-std-features=panic_immediate_abort` respectively. 
This ignores one of Rust's best features; its ecosystem.
For larger applications I speculate that macro optimizations are more important than the micro optimizations discussed in the aforementioned paper.
The article mentions that "inline-threshold=7 produces substantially smaller binaries in several embedded projects";
I have not heard about this technique before.

-->

# Results

<!-- FIXME: Rerun for host and compare targets separately -->

| Preset            | no-op no-std | no-op | hello-world | hello-logging | hello-logging deps | mqtt_logger |
|-------------------|--------------|-------|-------------|---------------|--------------------|-------------|
| stable-debug      | -            | 3656  | 3665        | 23537         | 7169               |             |
| stable-release    | -            | 421   | 427         | 2009          | 670                |             |
| stable-lossless   | -            | 346   | 352         | 1391          | 510                |             |
| stable-abort      | 9            | 340   | 346         | 1298          | 488                |             |
| stable-max        | 6            | 261   | 265         | 973           | 365                |             |
| unstable-lossless | -            | 353   | 359         | 1363          | 502                |             |
| unstable-abort    | 9            | 37    | 43          | 749           | 162                |             |
| unstable-max      | 6            | 23    | 27          | 479           | 99                 |             |

* `hello-logging` depends on `env-logger` which in turn depends on `regex` by default, which weighs in at <!-- FIXME -->

# Future work

I'm particularly interested in exploring techniques reducing the total size of applications that share dependencies,
for instance using `cdylib` and `dylib`.

# Appendix

## No Op

Represents the lower bound on the size of any app.
Could also be viewed as the constant factor in if we try to model the size of an app using some equation.

## Hello World

A common example that at first glance seems outrageously large.
I expect this will also help demonstrate the diminishing returns of `panic_immediate_abort`.

## Hello Logging

Included to demonstrate the difference turning off default features can make.

## MQTT Logger

Included to represent a small app that relies heavily on dependencies.
