
extension Array: PartiallyUpdatable where Element: Codable & PartiallyUpdatable & Identifiable, Element.ID: Codable {

    public enum Difference: Codable {
        case inserted(element: Element, index: Index)
        case removed(index: Index)
        case move(from: Index, to: Index)
        case update(update: Element.PartialUpdate, index: Index)
    }

    public func update(from oldValue: Self) -> [Difference]? {

        let difference = self.map(\.id).difference(from: oldValue.map(\.id)).inferringMoves()

        guard !difference.isEmpty else {
            return nil
        }

        let newValues = self.reduce(into: [:]) { $0[$1.id] = $1 }
        let oldValues = oldValue.reduce(into: [:]) { $0[$1.id] = $1 }

        var updates = [Difference]()
        for change in difference {
            switch change {
            case let .insert(index, id, removalIndex):
                if let removalIndex {
                    updates.append(.move(from: removalIndex, to: index))
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
                let oldValue = oldValues[element.id],
                let update = element.update(from: oldValue)
            else {
                continue
            }
            updates.append(.update(update: update, index: index))
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
            case let .move(from, to):
                let element = newValue.remove(at: from)
                newValue.insert(element, at: to)
            case let .update(update, index):
                newValue[index] = try newValue[index].updated(with: update)
            }
        }

        return newValue
    }
}
