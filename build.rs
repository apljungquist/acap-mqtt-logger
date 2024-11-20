use std::process::Command;
use std::{env, fs, path};

fn main() {
    let out_dir = path::PathBuf::from(env::var("OUT_DIR").unwrap());
    match fs::create_dir(&out_dir) {
        Ok(()) => Ok(()),
        Err(e) if e.kind() == std::io::ErrorKind::AlreadyExists => Ok(()),
        Err(e) => Err(e),
    }
    .unwrap();
    let license = out_dir.join("LICENSE");
    assert!(Command::new("cargo-about")
        .arg("generate")
        .arg("--fail")
        .args(["--manifest-path", "Cargo.toml"])
        .args(["--output-file", license.to_str().unwrap()])
        .arg("about.hbs")
        .status()
        .unwrap()
        .success())
}
