fn main() {
    eprintln!("Hello stderr!");
    println!("Hello stdout!");
    acap_logging::init_logger();
}