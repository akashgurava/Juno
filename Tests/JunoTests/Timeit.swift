import Dispatch
import Foundation

public struct Timer {
    private var start: DispatchTime
    private var end = DispatchTime(uptimeNanoseconds: 0)

    public init() {
        start = DispatchTime.now()
    }

    public mutating func stop() {
        end = DispatchTime.now()
    }

    public func getTime() -> UInt64 {
        if end.uptimeNanoseconds == 0 {
            print("Warning Timer.stop() never called")
        }
        return end.uptimeNanoseconds - start.uptimeNanoseconds
    }

    public func getTimeAsString() -> String {
        return formatTime(Double(getTime()))
    }
}

public func formatTime(precision: Int = 3, _ nanoseconds: Double) -> String {
    assert(precision > 0)

    if nanoseconds >= 60e9 {
        let seconds = UInt64(nanoseconds / 1e9)
        let parts: [(String, UInt64)] = [
            ("d", 60 * 60 * 24), ("h", 60 * 60), ("min", 60), ("s", 1),
        ]
        var time: [String] = []
        var leftover = seconds
        for (suffix, length) in parts {
            let value = leftover / length
            if value > 0 {
                leftover = leftover % length
                time.append("\(value)\(suffix)")
            }
            if leftover < 1 {
                break
            }
        }
        return time.joined(separator: " ")
    }

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

public struct TimeitResult: CustomStringConvertible {
    private let precision: Int

    let label: String
    let loops: Int
    let repetitions: Int
    let allRuns: [UInt64]
    let timings: [Double]

    let best: Double
    let worst: Double
    let sum: Double
    let mean: Double
    let stdDev: Double
    let diff: Double
    let warning: String?

    public init(
        label: String,
        loops: Int,
        repetitions: Int,
        allRuns: [UInt64],
        precision: Int
    ) {
        assert(allRuns.count == repetitions)
        assert(allRuns.count > 0)

        self.precision = precision

        self.label = label
        self.loops = loops
        self.repetitions = repetitions
        self.allRuns = allRuns
        self.timings = allRuns.map { Double($0) / Double(loops) }

        self.best = Double(allRuns.min()!) / Double(loops)
        self.worst = Double(allRuns.max()!) / Double(loops)
        self.sum = timings.reduce(0, +)
        self.mean = self.sum / Double(timings.count)
        self.stdDev = 0
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

    public var description: String {
        guard let warning = warning else {
            return """
                \(label): Loops: \(loops). Repetitions: \(repetitions).
                    Total Time: \(formatTime(precision: precision, sum)).
                    Mean: \(formatTime(precision: precision, mean)). \
                StdDev: \(formatTime(precision: precision, stdDev)). \
                Best: \(formatTime(precision: precision, best)). \
                Worst: \(formatTime(precision: precision, worst)).
                """
        }
        return """
            \(label): Loops: \(loops). Repetitions: \(repetitions).
                Total Time: \(formatTime(precision: precision, sum)).
                Mean: \(formatTime(precision: precision, mean)). \
            StdDev: \(formatTime(precision: precision, stdDev)). \
            Best: \(formatTime(precision: precision, best)). \
            Worst: \(formatTime(precision: precision, worst)).
                \(warning)
            """
    }
}

private func getAverageExecutionTime(loops: Int, f: () -> Void) -> UInt64 {
    f()
    var timer = Timer()
    for _ in 0..<loops {
        f()
    }
    timer.stop()
    return timer.getTime()
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
    loops: Int = 0,
    repetitions: Int = 7,
    precision: Int = 3,
    _ f: () -> Void
) {
    var number = loops
    if number == 0 {
        for index in 0..<10 {
            number = Int(pow(10.0, Double(index)))
            let time_number = getAverageExecutionTime(loops: number, f: f)
            if Double(time_number) >= 0.2 * 1e9 {
                break
            }
        }
    }
    let allRuns: [UInt64] = (0..<repetitions).map({ _ in
        getAverageExecutionTime(loops: number, f: f)
    })
    let result = TimeitResult(
        label: label,
        loops: number, repetitions: repetitions, allRuns: allRuns,
        precision: precision
    )
    print(result)
}
