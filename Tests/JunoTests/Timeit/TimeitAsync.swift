import Dispatch
import Foundation

/// Timer to determine time difference between init and stop.
public enum AsyncTimer {
    /// Measure a function.
    /// - Parameter callable: Function
    /// - Returns: Time taken in nanoseconds.
    public static func measure(_ callable: () async throws -> Void) async -> UInt64? {
        let start = DispatchTime.now().uptimeNanoseconds
        guard (try? await callable()) != nil else {
            return nil
        }
        return DispatchTime.now().uptimeNanoseconds - start
    }

    /// Execute function callable, `loops` times.
    /// And return array of time taken for each loop in nanoseconds.
    /// - Parameters:
    ///   - loops: Number of loops to execute.
    ///   - callable: Function whose time needs to be measured
    /// - Returns: Array of time taken for each loop.
    public static func measure(
        loops: Int,
        callable: () async throws -> Void
    ) async -> [UInt64] {
        try? await callable()
        var times: [UInt64] = []
        for _ in (0..<loops) {
            if let time = await Self.measure(callable) {
                times.append(time)
            }
        }
        return times
    }

    /// Suggest optimal number of loops.
    /// - Parameter callable: Timing function.
    /// - Returns: Number of loops.
    public static func suggestLoops(callable: () async throws -> Void) async -> Int {
        for index in 1...10 {
            let number = Int(pow(10.0, Double(index - 1)))
            let timeTaken = await Self.measure(loops: number, callable: callable)
            // Until timeTaken > 1 second
            if timeTaken.total >= UInt64(1e9) {
                return index
            }
        }
        return 1
    }
}

/// Times the execution of a function multiple times.
/// Good for measuring very fast functions.
///
///
/// Example:
/// ```
/// timeit {
///    2 + 2
/// }
/// timeit(loops: 100, repetitions: 10){
///    2 + 2
/// }
/// ```
/// - Parameter:
///    - loops: Number of times to execute the function in a loop. If loops is not
///        provided, loops is determined so as to get sufficient accuracy.
///    - iterations: Number of repetitions of loops of the function to average.
///    - precision: How many digits of precision to print
///    - f: The function to time
public func timeit(
    label: String,
    loops: Int = 0,
    iterations: Int = 7,
    precision: Int = 3,
    _ callable: () async throws -> Void
) async {
    var numLoops = loops
    if numLoops == 0 {
        numLoops = await AsyncTimer.suggestLoops(callable: callable)
    }
    var iterLoopTimes: [[UInt64]] = []
    for _ in (0..<iterations) {
        iterLoopTimes.append(
            await AsyncTimer.measure(loops: numLoops, callable: callable)
        )
    }
    let result = TimeitResult(
        label: label,
        loops: numLoops,
        iterations: iterations,
        iterLoopTimes: iterLoopTimes,
        precision: precision
    )
    print(result)
}
