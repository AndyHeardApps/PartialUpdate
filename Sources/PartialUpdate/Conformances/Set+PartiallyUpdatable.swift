
extension Set: PartiallyUpdatable where Element: PartiallyUpdatable {

    public enum Difference {
        case inserted(element: Element)
        case removed(element: Element)
        case updated(update: Element.PartialUpdate, id: String)
    }

    public func update(from oldValue: Self) -> [Difference]? {

        guard self != oldValue else {
            return nil
        }

        let oldValues = oldValue.reduce(into: [:]) { $0[id($1)] = $1 }
        let newValues = self.reduce(into: [:]) { $0[id($1)] = $1 }

        let oldIDs = Set<String>(oldValues.keys)
        let newIDs = Set<String>(newValues.keys)

        let removedIDs = oldIDs.subtracting(newIDs)
        let insertedIDs = newIDs.subtracting(oldIDs)
        let staticIDs = oldIDs.intersection(newIDs)

        var updates = [Difference]()
        for id in removedIDs {
            guard let value = oldValues[id] else {
                continue
            }
            updates.append(.removed(element: value))
        }
        for id in insertedIDs {
            guard let value = newValues[id] else {
                continue
            }
            updates.append(.inserted(element: value))
        }

        for id in staticIDs {
            guard
                let newValue = newValues[id],
                let oldValue = oldValues[id],
                let update = newValue.update(from: oldValue)
            else {
                continue
            }
            updates.append(.updated(update: update, id: "\(id)"))
        }

        return updates
    }

    public func updated(with partialUpdate: [Difference]?) throws -> Self {

        guard let partialUpdate else {
            return self
        }

        var values = self.reduce(into: [:]) { $0[id($1)] = $1 }
        for update in partialUpdate {
            switch update {
            case let .inserted(element):
                values[id(element)] = element
            case let .removed(element):
                values.removeValue(forKey: id(element))
            case let .updated(update, id):
                values[id] = try values.first { $0.key == id }?.value.updated(with: update)
            }
        }

        let newValue = Set(values.values)

        return newValue
    }

    private func id(_ element: Element) -> String {
        if let id = (element as? any Identifiable)?.id {
            "\(id)"
        } else {
            "\(element.hashValue)"
        }
    }
}

// MARK: - Coding keys
extension Set.Difference where Element: PartiallyUpdatable {

    private enum CodingKeys: String, CodingKey {
        case inserted = "i"
        case removed = "r"
        case updated = "u"
    }

    private enum ChildCodingKeys: String, CodingKey {
        case element = "e"
        case id = "id"
        case update = "u"
    }
}

// MARK: - Encodable
extension Set.Difference: Encodable
where Element: Encodable & PartiallyUpdatable,
      Element.PartialUpdate: Encodable
{

    public func encode(to encoder: any Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .inserted(element):
            var childContainer = container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .inserted)
            try childContainer.encode(element, forKey: .element)

        case let .removed(element):
            var childContainer = container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .removed)
            try childContainer.encode(element, forKey: .element)

        case let .updated(update, id):
            var childContainer = container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .updated)
            try childContainer.encode(update, forKey: .update)
            try childContainer.encode(id, forKey: .id)

        }
    }
}

// MARK: - Decodable
extension Set.Difference: Decodable
where Element: Decodable & PartiallyUpdatable,
      Element.PartialUpdate: Decodable
{

    public init(from decoder: any Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard container.allKeys.count == 1 else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Incorrect number top level keys found for \"Set.Difference\"."
                )
            )
        }

        switch container.allKeys[0] {
        case .inserted:
            let childContainer = try container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .inserted)
            self = try .inserted(
                element: childContainer.decode(Element.self, forKey: .element)
            )

        case .removed:
            let childContainer = try container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .removed)
            self = try .removed(
                element: childContainer.decode(Element.self, forKey: .element)
            )

        case .updated:
            let childContainer = try container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .updated)
            self = try .updated(
                update: childContainer.decode(Element.PartialUpdate.self, forKey: .update),
                id: childContainer.decode(String.self, forKey: .id)
            )
        }
    }
}
