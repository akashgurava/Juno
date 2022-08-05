use serde::{Deserialize, Serialize};

#[derive(Default, Debug, Clone, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct SfCityLot {
    #[serde(rename = "type")]
    pub type_field: String,
    pub properties: Properties,
    pub geometry: Option<Geometry>,
}

#[derive(Default, Debug, Clone, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Properties {
    #[serde(rename = "STREET")]
    pub street: Option<String>,
    #[serde(rename = "BLKLOT")]
    pub blklot: String,
    #[serde(rename = "TO_ST")]
    pub to_st: Option<String>,
    #[serde(rename = "LOT_NUM")]
    pub lot_num: String,
    #[serde(rename = "BLOCK_NUM")]
    pub block_num: String,
    #[serde(rename = "MAPBLKLOT")]
    pub mapblklot: String,
    #[serde(rename = "ODD_EVEN")]
    pub odd_even: Option<String>,
    #[serde(rename = "FROM_ST")]
    pub from_st: Option<String>,
}

#[derive(Default, Debug, Clone, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Geometry {
    #[serde(rename = "type")]
    pub type_field: String,
    pub coordinates: Vec<Vec<Vec<f64>>>,
}
