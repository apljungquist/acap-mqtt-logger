use log::{debug, error, info, trace, warn};

fn main() {
    eprintln!("Hello stderr!");
    println!("Hello stdout!");
    acap_logging::init_logger();
    trace!("Hello trace!");
    debug!("Hello debug!");
    info!("Hello info!");
    warn!("Hello warn!");
    error!("Hello error!");
}