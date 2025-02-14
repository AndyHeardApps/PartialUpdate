import Foundation

extension Optional: PartiallyUpdatable where Wrapped: Codable & PartiallyUpdatable {

    public func updated(with partialUpdate: PartialUpdate?) throws -> Optional<Wrapped> {
        switch partialUpdate {
        case let .value(wrapped):
            return .some(wrapped)
        case let .update(update):
            guard let value = self else {
                throw PartialUpdateError.updatingNilWithPartialValue
            }
            return try .some(value.updated(with: update))
        case .nullify:
            return .none
        case .none:
            return self
        }
    }

    public func update(from oldValue: Optional<Wrapped>) -> PartialUpdate? {
        switch (oldValue, self) {
        case (_?, nil):
            .nullify
        case let (nil, newValue?):
            .value(newValue)
        case (nil, nil):
            nil
        case let (oldValue?, newValue?):
            newValue.update(from: oldValue).map { .update($0) }
        }
    }
}

// MARK: - Partial model
extension Optional where Wrapped: Codable & PartiallyUpdatable {
    public enum PartialUpdate: Codable {

        case value(Wrapped)
        case update(Wrapped.PartialUpdate)
        case nullify
    }
}
