import Foundation

/// File open reason.
internal enum OpenReason: String {
    /// Read a file.
    case read = "READ"
    /// Write a file.
    case write = "WRITE"
}

/// File action.
internal enum Action {
    /// Open.
    case fileOpen(reason: OpenReason)
    /// Query.
    case query
    /// Read.
    case read(total: Int, read: Int)
    /// Write.
    case write(total: Int, wrote: Int)
}

/// Read error representor.
internal struct FileError: Error, CustomStringConvertible {
    /// Path.
    let path: String
    /// Action.
    let action: Action

    /// Error description.
    var description: String {
        switch self.action {
        case let .fileOpen(reason):
            return "Path: \(path). Opening for: \(reason). Could not open file."
        case .query:
            return "Path: \(path). Could not query information about file."
        case let .read(total, read):
            return """
                Path: \(path). Expected total: \(total). Success Read: \(read).
                """
        case let .write(total, wrote):
            return """
                Path: \(path). Expected total: \(total). Success Write: \(wrote).
                """
        }
    }
}

/// File.
internal struct File {
    /// File pointer.
    typealias Descriptor = UnsafeMutablePointer<FILE>

    /// Path of file.
    let path: String

    /// Get total file size.
    /// - Parameter descriptor: Pointer from beginning of file.
    /// - Returns: File size
    private func count(descriptor: Descriptor) throws -> Int? {
        let descriptor: Int32 = fileno(descriptor)
        guard descriptor != -1
        else {
            throw FileError(path: "", action: .query)
        }
        var status: stat = .init()
        guard fstat(descriptor, &status) == 0
        else {
            return nil
        }
        switch status.st_mode & S_IFMT {
        case S_IFREG, S_IFLNK:
            return Int(status.st_size)

        default:
            return nil
        }
    }

    /// Read a file as bytes.
    /// - Returns: Byte array.
    internal func read() throws -> [UInt8] {
        guard let descriptor: Descriptor = fopen(path, "rb")
        else {
            throw FileError(path: path, action: .fileOpen(reason: .read))
        }
        // Close the file before exiting this function.
        defer {
            fclose(descriptor)
        }
        guard let count = try count(descriptor: descriptor)
        else {
            throw FileError(path: path, action: .query)
        }

        let buffer: [UInt8] = .init(unsafeUninitializedCapacity: count) { addr, desc in
            desc = fread(addr.baseAddress, 1, count, descriptor)
        }
        guard buffer.count == count
        else {
            throw FileError(
                path: path, action: .read(total: count, read: buffer.count)
            )
        }
        return buffer
    }

    /// Read a file as string.
    /// - Returns: String data.
    internal func read() throws -> String {
        guard let descriptor: Descriptor = fopen(path, "rb")
        else {
            throw FileError(path: path, action: .fileOpen(reason: .read))
        }
        // Close the file before exiting this function.
        defer {
            fclose(descriptor)
        }
        guard let count = try count(descriptor: descriptor)
        else {
            throw FileError(path: path, action: .query)
        }

        return try .init(unsafeUninitializedCapacity: count) { addr in
            let initialized: Int = fread(addr.baseAddress, 1, count, descriptor)
            guard initialized == count
            else {
                throw FileError(
                    path: path, action: .read(total: count, read: initialized)
                )
            }
            return initialized
        }
    }

    /// Write data to file.
    /// - Parameters:
    ///   - buffer: Data to write.
    internal func write(_ buffer: [UInt8]) throws {
        guard let descriptor: Descriptor = fopen(path, "wb")
        else {
            throw FileError(path: path, action: .fileOpen(reason: .write))
        }
        defer {
            fclose(descriptor)
        }
        let count: Int = buffer.withUnsafeBufferPointer { addr in
            fwrite(addr.baseAddress, 1, addr.count, descriptor)
        }
        guard count == buffer.count
        else {
            throw FileError(
                path: path, action: .write(total: buffer.count, wrote: count)
            )
        }
    }
}
