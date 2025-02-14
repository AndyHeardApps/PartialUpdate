
extension Dictionary: PartiallyUpdatable where Value: Codable & PartiallyUpdatable, Key: Codable {

    public enum Difference: Codable {
        case inserted(value: Value, key: Key)
        case removed(key: Key)
        case update(update: Value.PartialUpdate, key: Key)
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
            updates.append(.update(update: update, key: key))
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
            case let .update(update, key):
                newValue[key] = try newValue[key]?.updated(with: update)
            }
        }

        return newValue
    }
}
