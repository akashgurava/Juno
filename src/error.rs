#[derive(Debug, thiserror::Error)]
pub enum JunoRustError {
    #[error("Could not read file.")]
    FileReadError(#[from] std::io::Error),
    #[error("Could not serialize JSON file.")]
    SerializeError(#[from] serde_json::Error),
}
