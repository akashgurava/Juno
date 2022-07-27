/// A storage.
public protocol Store {
    /// Store a object.
    /// - Parameter object: Object ot store.
    func store<T: Table>(object: T) throws
}

extension Store {}
