
extension Set: PartiallyUpdatable where Element: Codable & PartiallyUpdatable & Identifiable, Element.ID: Codable {

    public enum Difference: Codable {
        case inserted(element: Element)
        case removed(id: Element.ID)
        case update(update: Element.PartialUpdate, id: Element.ID)
    }

    public func update(from oldValue: Self) -> [Difference]? {

        guard self != oldValue else {
            return nil
        }

        let oldValues = oldValue.reduce(into: [:]) { $0[$1.id] = $1 }
        let newValues = self.reduce(into: [:]) { $0[$1.id] = $1 }

        let oldIDs = Set<Element.ID>(oldValues.keys)
        let newIDs = Set<Element.ID>(newValues.keys)

        let removedIDs = oldIDs.subtracting(newIDs)
        let insertedIDs = newIDs.subtracting(oldIDs)
        let staticIDs = oldIDs.intersection(newIDs)

        var updates = [Difference]()
        for id in removedIDs {
            updates.append(.removed(id: id))
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
            updates.append(.update(update: update, id: id))
        }

        return updates
    }

    public func updated(with partialUpdate: [Difference]?) throws -> Self {

        guard let partialUpdate else {
            return self
        }

        var values = self.reduce(into: [:]) { $0[$1.id] = $1 }
        for update in partialUpdate {
            switch update {
            case let .inserted(element):
                values[element.id] = element
            case let .removed(id):
                values.removeValue(forKey: id)
            case let .update(update, id):
                values[id] = try values[id]?.updated(with: update)
            }
        }

        let newValue = Set(values.values)

        return newValue
    }
}
