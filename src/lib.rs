use std::sync::Arc;

uniffi::setup_scaffolding!();

#[uniffi::export]
pub trait Person: Send + Sync + std::fmt::Debug {
    fn name(&self) -> String;
}

#[uniffi::export]
pub fn greet(table: Arc<dyn Person>) {
    println!("Hello!! {}", table.name())
}
