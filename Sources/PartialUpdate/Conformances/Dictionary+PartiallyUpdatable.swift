
extension Dictionary: PartiallyUpdatable where Value: PartiallyUpdatable {

    public enum Difference {
        case inserted(value: Value, key: Key)
        case removed(key: Key)
        case updated(update: Value.PartialUpdate, key: Key)
    }

    public func update(from oldValue: Self) -> [Difference]? {

        guard self != oldValue else {
            return nil
        }

        let oldKeys = Set(oldValue.keys)
        let newKeys = Set(keys)

        let removedKeys = oldKeys.subtracting(newKeys)
        let insertedKeys = newKeys.subtracting(oldKeys)
        let staticKeys = oldKeys.intersection(newKeys)

        var updates = [Difference]()
        for key in removedKeys {
            updates.append(.removed(key: key))
        }
        for key in insertedKeys {
            guard let value = self[key] else {
                continue
            }
            updates.append(.inserted(value: value, key: key))
        }

        for key in staticKeys {
            guard
                let newValue = self[key],
                let oldValue = oldValue[key],
                let update = newValue.update(from: oldValue)
            else {
                continue
            }
            updates.append(.updated(update: update, key: key))
        }

        return updates
    }

    public func updated(with partialUpdate: [Difference]?) throws -> Self {

        guard let partialUpdate else {
            return self
        }

        var newValue = self
        for update in partialUpdate {
            switch update {
            case let .inserted(value, key):
                newValue[key] = value
            case let .removed(key):
                newValue.removeValue(forKey: key)
            case let .updated(update, key):
                newValue[key] = try newValue[key]?.updated(with: update)
            }
        }

        return newValue
    }
}

// MARK: - Coding keys
extension Dictionary.Difference where Value: PartiallyUpdatable {

    private enum CodingKeys: String, CodingKey {
        case inserted = "i"
        case removed = "r"
        case updated = "u"
    }

    private enum ChildCodingKeys: String, CodingKey {
        case key = "k"
        case value = "v"
        case update = "u"
    }
}

// MARK: - Encodable
extension Dictionary.Difference: Encodable
where Value: Encodable & PartiallyUpdatable,
      Value.PartialUpdate: Encodable,
      Key: Encodable
{

    public func encode(to encoder: any Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .inserted(value, key):
            var childContainer = container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .inserted)
            try childContainer.encode(value, forKey: .value)
            try childContainer.encode(key, forKey: .key)

        case let .removed(key):
            var childContainer = container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .removed)
            try childContainer.encode(key, forKey: .key)

        case let .updated(update, key):
            var childContainer = container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .updated)
            try childContainer.encode(update, forKey: .update)
            try childContainer.encode(key, forKey: .key)

        }
    }
}

// MARK: - Decodable
extension Dictionary.Difference: Decodable
where Value: Decodable & PartiallyUpdatable,
      Value.PartialUpdate: Decodable,
      Key: Decodable
{

    public init(from decoder: any Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard container.allKeys.count == 1 else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Incorrect number top level keys found for \"Dictionary.Difference\"."
                )
            )
        }

        switch container.allKeys[0] {
        case .inserted:
            let childContainer = try container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .inserted)
            self = try .inserted(
                value: childContainer.decode(Value.self, forKey: .value),
                key: childContainer.decode(Key.self, forKey: .key)
            )

        case .removed:
            let childContainer = try container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .removed)
            self = try .removed(
                key: childContainer.decode(Key.self, forKey: .key)
            )

        case .updated:
            let childContainer = try container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .updated)
            self = try .updated(
                update: childContainer.decode(Value.PartialUpdate.self, forKey: .update),
                key: childContainer.decode(Key.self, forKey: .key)
            )
        }
    }
}
