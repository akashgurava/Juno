use std::fmt::Debug;
use std::fs::File;
use std::io::BufReader;

use crate::JunoRustError;

pub trait Table: Send + Sync + Debug {}

pub trait Store {
    fn read_all(&self) -> Result<Vec<Box<dyn Table>>, JunoRustError>;
}

#[derive(Debug)]
pub struct JsonStore {
    path: String,
}

impl Store for JsonStore {
    fn read_all(&self) -> Result<Vec<Box<dyn Table>>, JunoRustError> {
        let _reader = BufReader::new(File::open(&self.path)?);
        // let t: Vec<dyn Table> = serde_json::from_reader(reader).unwrap();
        todo!()
    }
}

impl JsonStore {
    pub fn new(path: String) -> Self {
        Self { path }
    }
}
