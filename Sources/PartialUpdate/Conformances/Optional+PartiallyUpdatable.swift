import Foundation

extension Optional: PartiallyUpdatable where Wrapped: PartiallyUpdatable {

    public enum PartialUpdate {
        case full(Wrapped)
        case updated(Wrapped.PartialUpdate)
        case nullified
    }

    public func updated(with partialUpdate: PartialUpdate?) throws -> Optional<Wrapped> {
        switch partialUpdate {
        case let .full(wrapped):
            return .some(wrapped)
        case let .updated(update):
            guard let value = self else {
                throw PartialUpdateError.updatingNilWithPartialValue
            }
            return try .some(value.updated(with: update))
        case .nullified:
            return .none
        case .none:
            return self
        }
    }

    public func update(from oldValue: Optional<Wrapped>) -> PartialUpdate? {
        switch (oldValue, self) {
        case (_?, nil):
            .nullified
        case let (nil, newValue?):
            .full(newValue)
        case (nil, nil):
            nil
        case let (oldValue?, newValue?):
            newValue.update(from: oldValue).map { .updated($0) }
        }
    }
}

// MARK: - Coding keys
extension Optional.PartialUpdate where Wrapped: PartiallyUpdatable {

    private enum CodingKeys: String, CodingKey {
        case full = "f"
        case updated = "u"
        case nullified = "n"
    }

    private enum ChildCodingKeys: String, CodingKey {
        case value = "v"
        case update = "u"
    }
}

// MARK: - Encodable
extension Optional.PartialUpdate: Encodable
where Wrapped: Encodable & PartiallyUpdatable,
      Wrapped.PartialUpdate: Encodable
{

    public func encode(to encoder: any Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .full(value):
            var childContainer = container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .full)
            try childContainer.encode(value, forKey: .value)

        case let .updated(update):
            var childContainer = container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .updated)
            try childContainer.encode(update, forKey: .update)

        case .nullified:
            _ = container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .nullified)

        }
    }
}

// MARK: - Decodable
extension Optional.PartialUpdate: Decodable
where Wrapped: Decodable & PartiallyUpdatable,
      Wrapped.PartialUpdate: Decodable
{

    public init(from decoder: any Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard container.allKeys.count == 1 else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Incorrect number top level keys found for \"Optional.PartialUpdate\"."
                )
            )
        }

        switch container.allKeys[0] {
        case .full:
            let childContainer = try container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .full)
            self = try .full(
                childContainer.decode(Wrapped.self, forKey: .value)
            )

        case .updated:
            let childContainer = try container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .updated)
            self = try .updated(
                childContainer.decode(Wrapped.PartialUpdate.self, forKey: .update)
            )

        case .nullified:
            self = .nullified
        }
    }
}
