fn main() {
    uniffi_build::generate_scaffolding("./src/JunoRust.udl").expect("Building the UDL file failed");
}
