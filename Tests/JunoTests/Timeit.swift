import Dispatch
import Foundation

// swiftlint: disable file_types_order
extension Array where Element == UInt64 {
    var total: Element {
        self.reduce(.zero, +)
    }

    var mean: Double {
        Double(total) / Double(count)
    }
}

// swiftlint: disable file_types_order
extension Array where Element == Double {
    var sum: Element {
        self.reduce(.zero, +)
    }

    var mean: Double {
        sum / Double(count)
    }
}

/// Timer to determine time difference between init and stop.
public enum Timer {
    /// Measure a function.
    /// - Parameter callable: Function
    /// - Returns: Time taken in nanoseconds.
    public static func measure(_ callable: () -> Void) -> UInt64 {
        let start = DispatchTime.now().uptimeNanoseconds
        callable()
        return DispatchTime.now().uptimeNanoseconds - start
    }

    /// Execute function callable, `loops` times.
    /// And return array of time taken for each loop in nanoseconds.
    /// - Parameters:
    ///   - loops: Number of loops to execute.
    ///   - callable: Function whose time needs to be measured
    /// - Returns: Array of time taken for each loop.
    public static func measure(loops: Int, callable: () -> Void) -> [UInt64] {
        callable()
        return (0..<loops).map { _ in
            Self.measure(callable)
        }
    }

    /// Suggest optimal number of loops.
    /// - Parameter callable: Timing function.
    /// - Returns: Number of loops.
    public static func suggestLoops(callable: () -> Void) -> Int {
        for index in 0..<10 {
            let number = Int(pow(10.0, Double(index)))
            let timeTaken = Self.measure(loops: number, callable: callable)
            // Until timeTaken > 1 second
            if timeTaken.total >= UInt64(1e9) {
                return index
            }
        }
        return 1
    }
}

// swiftlint: disable function_default_parameter_at_end
/// Format time in nanoseconds to string.
/// - Parameters:
///   - precision: Decimal points.
///   - nanoseconds: Time taken in nanoseconds.
/// - Returns: Time in ns, µs, ms, s format
public func formatTime(precision: Int = 3, _ nanoseconds: Double) -> String {
    assert(precision > 0)

    if nanoseconds < 1e3 {
        return String(format: "%.\(precision)g ns", nanoseconds)
    } else if nanoseconds < 1e6 {
        return String(format: "%.\(precision)g µs", nanoseconds / 1e3)
    } else if nanoseconds < 1e9 {
        return String(format: "%.\(precision)g ms", nanoseconds / 1e6)
    } else {
        return String(format: "%.\(precision)g s", nanoseconds / 1e9)
    }
}

// swiftlint: disable function_default_parameter_at_end
/// Format time in nanoseconds to string.
/// - Parameters:
///   - precision: Decimal points.
///   - nanoseconds: Time taken in nanoseconds.
/// - Returns: Time in ns, µs, ms, s format
public func formatTime(precision: Int = 3, _ nanoseconds: UInt64) -> String {
    formatTime(precision: precision, Double(nanoseconds))
}

/// Structure to show Descriptive statistics of Time taken.
public struct TimeitResult: CustomStringConvertible {
    private let precision: Int

    /// Name of timeit.
    let label: String
    /// Number of loops per iteration.
    let loops: Int
    /// Number of iterations
    let iterations: Int
    /// Time taken per loop per iteration.
    let iterLoopTimes: [[UInt64]]

    /// Time taken per iteration.
    let totalIterTime: [UInt64]
    /// Mean time taken per loop in a iteration.
    let meanLoopTimes: [Double]

    /// Time taken for total execution.
    let total: UInt64
    /// Mean time taken for a loop in a iteration.
    let mean: Double
    /// Standard deviation time taken for a loop in a iteration.
    let stdDev: Double

    /// Lowest time taken for a loop in a iteration.
    let best: Double
    /// Highest time taken for a loop in a iteration.
    let worst: Double

    /// Difference between.
    let diff: Double
    /// Warning message to raise in case of caching.
    let warning: String?

    /// String representation.
    public var description: String {
        let desc = """
            \(label): Loops: \(loops). Iterations: \(iterations).
                Total time taken: \(formatTime(precision: precision, total)). \
            Mean: \(formatTime(precision: precision, mean)). \
            Std Dev: \(formatTime(precision: precision, stdDev)).
                Best: \(formatTime(precision: precision, best)). \
            Worst: \(formatTime(precision: precision, worst))
            """
        if let warning = warning {
            return "\(desc)\n\(warning)"
        }
        return desc
    }

    /// Create a timeit result.
    /// - Parameters:
    ///   - label: Label for callable.
    ///   - loops: Number of loops.
    ///   - iterations: Number of iterations.
    ///   - iterLoopTimes: Time of each loop in each iteration.
    ///   - precision: Number of decimal places to show
    public init(
        label: String,
        loops: Int,
        iterations: Int,
        iterLoopTimes: [[UInt64]],
        precision: Int
    ) {
        assert(iterLoopTimes.count == iterations)
        assert(!iterLoopTimes.isEmpty)

        self.precision = precision

        self.label = label
        self.loops = loops
        self.iterations = iterations
        self.iterLoopTimes = iterLoopTimes

        self.totalIterTime = iterLoopTimes.map { $0.total }
        self.meanLoopTimes = iterLoopTimes.map { $0.mean }

        self.total = totalIterTime.reduce(0, +)
        self.mean = meanLoopTimes.mean
        let mean = meanLoopTimes.mean
        self.stdDev = sqrt(
            iterLoopTimes.joined().map { pow(Double($0) - mean, 2) }.reduce(.zero, +)
                / Double(loops * iterations)
        )

        self.best = Double(meanLoopTimes.min() ?? 0) / Double(loops)
        self.worst = Double(meanLoopTimes.max() ?? 0) / Double(loops)
        self.diff = round(worst * 100 / best) / 100
        if diff > 2 {
            self.warning = """
                The slowest run took \(diff) times longer than the fastest.
                    This could mean that an intermediate result is being cached.
                """
        } else {
            self.warning = nil
        }
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
///    - repetitions: Number of repetitions of loops of the function to average.
///    - precision: How many digits of precision to print
///    - f: The function to time
public func timeit(
    label: String,
    loops: Int? = nil,
    repetitions: Int = 7,
    precision: Int = 3,
    _ callable: () -> Void
) {
    let loops = loops ?? Timer.suggestLoops(callable: callable)
    let iterLoopTimes: [[UInt64]] = (0..<repetitions).map { _ in
        Timer.measure(loops: loops, callable: callable)
    }
    let result = TimeitResult(
        label: label,
        loops: loops,
        iterations: repetitions,
        iterLoopTimes: iterLoopTimes,
        precision: precision
    )
    print(result)
}
