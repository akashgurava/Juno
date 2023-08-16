#[swift_bridge::bridge]
mod ffi {

    #[swift_bridge(swift_repr = "struct")]
    pub struct SharedData {
        id: u8,
        name: String,
    }

    extern "Rust" {
        fn make_data() -> SharedData;
    }
}
use ffi::SharedData;

fn make_data() -> SharedData {
    SharedData {
        id: 90,
        name: "".into(),
    }
}
