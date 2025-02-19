
extension Array: PartiallyUpdatable where Element: PartiallyUpdatable {

    public enum Difference {
        case inserted(element: Element, index: Index)
        case removed(index: Index)
        case moved(from: Index, to: Index)
        case updated(update: Element.PartialUpdate, index: Index)
    }

    public func update(from oldValue: Self) -> [Difference]? {

        guard self != oldValue else {
            return nil
        }

        var difference = self.identifiers.difference(from: oldValue.identifiers)
        if Element.self is any Identifiable.Type {
            difference = difference.inferringMoves()
        }

        let newValues = self.enumerated().reduce(into: [:]) { $0[id($1.element, index: $1.offset)] = $1.element }
        let oldValues = oldValue.enumerated().reduce(into: [:]) { $0[id($1.element, index: $1.offset)] = $1.element }

        var updates = [Difference]()
        for change in difference {
            switch change {
            case let .insert(index, id, removalIndex):
                if let removalIndex {
                    updates.append(.moved(from: removalIndex, to: index))
                } else if let element = newValues[id] {
                    updates.append(.inserted(element: element, index: index))
                }
            case let .remove(index, _, insertionIndex):
                if insertionIndex == nil {
                    updates.append(.removed(index: index))
                }
            }
        }

        for (index, element) in self.enumerated() {
            guard
                let oldValue = oldValues[id(element, index: index)],
                let update = element.update(from: oldValue)
            else {
                continue
            }
            updates.append(.updated(update: update, index: index))
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
            case let .inserted(element, index):
                newValue.insert(element, at: index)
            case let .removed(index):
                newValue.remove(at: index)
            case let .moved(from, to):
                let element = newValue.remove(at: from)
                newValue.insert(element, at: to)
            case let .updated(update, index):
                newValue[index] = try newValue[index].updated(with: update)
            }
        }

        return newValue
    }

    private func id(_ element: Element, index: Index) -> AnyHashable {
        if let id = (element as? any Identifiable)?.id {
            AnyHashable(id)
        } else {
            AnyHashable(index)
        }
    }

    private var identifiers: [AnyHashable] {
        enumerated().map { index, element in
            id(element, index: index)
        }
    }
}

// MARK: - Coding keys
extension Array.Difference where Element: PartiallyUpdatable {

    private enum CodingKeys: String, CodingKey {
        case inserted = "i"
        case removed = "r"
        case moved = "m"
        case updated = "u"
    }

    private enum ChildCodingKeys: String, CodingKey {
        case element = "e"
        case index = "i"
        case from = "f"
        case to = "t"
        case update = "u"
    }
}
// MARK: - Encodable
extension Array.Difference: Encodable
where Element: Encodable & PartiallyUpdatable,
      Element.PartialUpdate: Encodable
{

    public func encode(to encoder: any Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .inserted(element, index):
            var childContainer = container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .inserted)
            try childContainer.encode(element, forKey: .element)
            try childContainer.encode(index, forKey: .index)

        case let .removed(index):
            var childContainer = container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .removed)
            try childContainer.encode(index, forKey: .index)

        case let .moved(from, to):
            var childContainer = container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .moved)
            try childContainer.encode(from, forKey: .from)
            try childContainer.encode(to, forKey: .to)

        case let .updated(update, index):
            var childContainer = container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .updated)
            try childContainer.encode(update, forKey: .update)
            try childContainer.encode(index, forKey: .index)

        }
    }
}

// MARK: - Decodable
extension Array.Difference: Decodable
where Element: Decodable & PartiallyUpdatable,
      Element.PartialUpdate: Decodable
{

    public init(from decoder: any Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard container.allKeys.count == 1 else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Incorrect number top level keys found for \"Array.Difference\"."
                )
            )
        }

        switch container.allKeys[0] {
        case .inserted:
            let childContainer = try container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .inserted)
            self = try .inserted(
                element: childContainer.decode(Element.self, forKey: .element),
                index: childContainer.decode(Array.Index.self, forKey: .index)
            )

        case .removed:
            let childContainer = try container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .removed)
            self = try .removed(
                index: childContainer.decode(Array.Index.self, forKey: .index)
            )

        case .moved:
            let childContainer = try container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .moved)
            self = try .moved(
                from: childContainer.decode(Array.Index.self, forKey: .from),
                to: childContainer.decode(Array.Index.self, forKey: .to)
            )

        case .updated:
            let childContainer = try container.nestedContainer(keyedBy: ChildCodingKeys.self, forKey: .updated)
            self = try .updated(
                update: childContainer.decode(Element.PartialUpdate.self, forKey: .update),
                index: childContainer.decode(Array.Index.self, forKey: .index)
            )
            
        }
    }
}
