
public protocol PartiallyUpdatable: Hashable {

    // MARK: - Associated type
    associatedtype PartialUpdate: Codable

    // MARK: - Functions
    func updated(with partialUpdate: PartialUpdate?) throws -> Self
    func update(from oldValue: Self) -> PartialUpdate?
}

// MARK: - Error
public enum PartialUpdateError: Error {
    case updatingNilWithPartialValue
    case updatingEnumWithIncorrectCase
}
