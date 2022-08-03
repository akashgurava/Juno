#[derive(Debug, thiserror::Error)]
pub enum JunoRustError {
    #[error("Could not read file.")]
    FileReadError(#[from] std::io::Error),
}
