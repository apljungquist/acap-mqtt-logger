use log::{debug, error, info, trace, warn};

fn main() {
    eprintln!("Hello stderr!");
    println!("Hello stdout!");
    trace!("Hello trace!");
    debug!("Hello debug!");
    info!("Hello info!");
    warn!("Hello warn!");
    error!("Hello error!");
}