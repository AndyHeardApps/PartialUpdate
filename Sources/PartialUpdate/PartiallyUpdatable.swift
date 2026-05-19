
/// Indicates that a type can create an object mirroring itself, but only containing differences from some other instance of the same type, and can apply that difference object to update itself with those differences.
public protocol PartiallyUpdatable: Hashable {

    // MARK: - Associated type

    /// A type containing the differences between two instances of the same type.
    associatedtype PartialUpdate

    // MARK: - Functions

    /// Updates this instance with the provided `PartialUpdate` object.
    /// - Parameter partialUpdate: The object containing the changes to be applied to this instance. If `nil`, then no changes are made.
    /// - Returns: The updated instance of the object.
    func updated(with partialUpdate: PartialUpdate?) throws -> Self

    /// Creates a `PartialUpdate` object instance containing all the changes between this value, and the provided `oldValue`. The difference object should contain values on the calling instance only if it is not equal to that on the `oldValue`.
    /// - Parameter oldValue: The instance to compare values to and return only values that aren't equal. Equal values should be represented by `nil` to indicate no change.
    /// - Returns: The object containing the differences between this instance and the `oldValue`. If the two instances are equal, then `nil` is returned.
    func update(from oldValue: Self) -> PartialUpdate?
}

// MARK: - Error

/// Errors that can occur when applying a `PartialUpdate` instance to a `PartiallyUpdatable` instance.
public enum PartialUpdateError: Error {

    /// A `nil` optional value was attempted to be set to non-nil with only a partial set of data.
    case updatingNilWithPartialValue

    /// An enum case was attempted to be set to another case with a partial set off associated value data.
    case updatingEnumWithIncorrectCase
}
