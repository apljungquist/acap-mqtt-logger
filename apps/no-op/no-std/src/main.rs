#![no_std]
#![no_main]

use core::panic::PanicInfo;

#[panic_handler]
fn my_panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
pub extern "C" fn main(_argc: isize, _argv: *const *const u8) -> isize {
    0
}