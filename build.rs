fn main() {
    uniffi_build::generate_scaffolding("./src/junorust.udl").expect("Building the UDL file failed");
}
