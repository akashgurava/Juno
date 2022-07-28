import Foundation

/// Measure a block for performance.
/// - Parameters:
///   - label: Name of block for identifying.
///   - tests: Number of tests to run.
///   - printResults: Should the results be printed?
///   - setup: Any setup required.
///   - block: Main block execution to measure.
/// - Returns: Average execution time.
@_transparent public func measureBlock(
    label: String,
    tests: Int = 1,
    printResults output: Bool = true,
    setup: @escaping () -> Void = {},
    _ block: @escaping () throws -> Void
) throws {
    guard tests > 0 else { fatalError("Number of tests must be greater than 0") }

    let start = CFAbsoluteTimeGetCurrent()
    var iterTime: [CFAbsoluteTime] = []
    for _ in 1...tests {
        setup()
        let start = CFAbsoluteTimeGetCurrent()
        try block()
        iterTime.append(CFAbsoluteTimeGetCurrent() - start)
    }
    let end = CFAbsoluteTimeGetCurrent()

    if output {
        print(label, "▿")
        print("\tNumber of tests: \(tests)\n")
        print("\tExecution time: \(end - start)s")
    }
}

/// Generate a random string.
/// - Parameter length: Length of required string.
/// - Returns: Random string.
public func randomString(_ length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map { _ in letters.randomElement() ?? "J" })
}
