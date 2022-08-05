use std::fs::read;

pub mod error;
pub mod types;

pub use error::JunoRustError;

pub use types::{Geometry, Properties, SfCityLot};

pub fn read_json(path: String) -> Result<Vec<SfCityLot>, JunoRustError> {
    let data = read(path)?;
    let data: Vec<SfCityLot> = serde_json::from_slice(&data)?;
    Ok(data)
}

uniffi_macros::include_scaffolding!("JunoRust");
