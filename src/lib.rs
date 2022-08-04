pub mod error;
pub mod table;

pub use error::JunoRustError;
pub use table::{JsonStore, Store, Table};

uniffi_macros::include_scaffolding!("JunoRust");
