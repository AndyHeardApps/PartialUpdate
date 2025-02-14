import Foundation
import PartialUpdate

struct Child: PartiallyUpdatable, Identifiable, Codable {

    let id: UUID
    var string: String?
    var int: Int?
    var double: Double

    init(
        id: UUID = .init(),
        string: String? = "string",
        int: Int? = nil,
        double: Double = 5.5
    ) {
        self.id = id
        self.string = string
        self.int = int
        self.double = double
    }

    struct PartialUpdate: Codable {
        let id: UUID.PartialUpdate?
        let string: String?.PartialUpdate?
        let int: Int?.PartialUpdate?
        let double: Double.PartialUpdate?
    }

    func update(from oldValue: Child) -> PartialUpdate? {
        guard self != oldValue else {
            return nil
        }

        return .init(
            id: id.update(from: oldValue.id),
            string: string.update(from: oldValue.string),
            int: int.update(from: oldValue.int),
            double: double.update(from: oldValue.double)
        )
    }

    func updated(with partialUpdate: PartialUpdate?) throws -> Child {
        try Child(
            id: id.updated(with: partialUpdate?.id),
            string: string.updated(with: partialUpdate?.string),
            int: int.updated(with: partialUpdate?.int),
            double: double.updated(with: partialUpdate?.double)
        )
    }
}

struct Parent: PartiallyUpdatable {

    var bool: Bool
    var array: [Child]
    var dictionary: [Int : String]
    var `set`: Set<Child>
    var option: Option

    init(
        bool: Bool = false,
        array: [Child] = [
            .init(),
            .init(),
            .init(),
            .init()
        ],
        dictionary: [Int : String] = [
            1 : "one",
            2 : "two",
            3 : "three",
            4 : "four"
        ],
        `set`: Set<Child> = [
            .init(),
            .init(),
            .init(),
            .init()
        ],
        option: Option = .person("First", nil)
    ) {
        self.bool = bool
        self.array = array
        self.dictionary = dictionary
        self.set = set
        self.option = option
    }

    struct PartialUpdate: Codable {
        let bool: Bool.PartialUpdate?
        let array: [Child].PartialUpdate?
        let dictionary: [Int : String].PartialUpdate?
        let set: Set<Child>.PartialUpdate?
        let option: Option.PartialUpdate?
    }

    func update(from oldValue: Parent) -> PartialUpdate? {
        guard self != oldValue else {
            return nil
        }

        return .init(
            bool: bool.update(from: oldValue.bool),
            array: array.update(from: oldValue.array),
            dictionary: dictionary.update(from: oldValue.dictionary),
            set: set.update(from: oldValue.set),
            option: option.update(from: oldValue.option)
        )
    }

    func updated(with partialUpdate: PartialUpdate?) throws -> Parent {
        try Parent(
            bool: bool.updated(with: partialUpdate?.bool),
            array: array.updated(with: partialUpdate?.array),
            dictionary: dictionary.updated(with: partialUpdate?.dictionary),
            set: set.updated(with: partialUpdate?.set),
            option: option.updated(with: partialUpdate?.option)
        )
    }
}

enum Option: PartiallyUpdatable & Codable {
    case int(Int)
    case person(String, String?)
    case flat

    enum PartialUpdate: Codable {
        case int(Int.PartialUpdate?)
        case person(String.PartialUpdate?, String?.PartialUpdate?)
        case flat
        case caseChange(Option)
    }

    func update(from oldValue: Option) -> PartialUpdate? {

        guard self != oldValue else {
            return nil
        }

        switch (self, oldValue) {
        case let (.int(newInt), .int(oldInt)):
            return .int(
                newInt.update(from: oldInt)
            )
        case let (.person(newString, newString2), .person(oldString, oldString2)):
            return .person(
                newString.update(from: oldString),
                newString2.update(from: oldString2)
            )
        case (.flat, .flat):
            return .flat

        default:
            return .caseChange(self)

        }
    }

    func updated(with partialUpdate: PartialUpdate?) throws -> Option {
        guard let partialUpdate else {
            return self
        }

        switch (self, partialUpdate) {
        case let (.int(int), .int(intUpdate)):
            return try .int(int.updated(with: intUpdate))
        case let (.person(string, string2), .person(stringUpdate, string2Update)):
            return try .person(
                string.updated(with: stringUpdate),
                string2.updated(with: string2Update)
            )
        case (.flat, .flat):
            return .flat
        case let (_, .caseChange(update)):
            return update
        default:
            throw PartialUpdateError.updatingEnumWithIncorrectCase
        }
    }
}

let inital = Parent()
var updated = inital
updated.bool.toggle()
updated.array.insert(updated.array.remove(at: 1), at: 2)
updated.array[2].int = 3
updated.array[0].double = 0
updated.array[1].string = nil
updated.dictionary.removeValue(forKey: 2)
updated.dictionary[5] = "five"
updated.dictionary[3] = "THREE"
updated.set.removeFirst()
updated.set.insert(.init())
var child = updated.set.randomElement()!
updated.set.remove(child)
child.int = 0
child.string = "New"
updated.set.insert(child)
updated.option = .person("First", "Second")

let update = updated.update(from: inital)

let decoder = JSONDecoder()
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let jsonData = try encoder.encode(update)
print(String(data: jsonData, encoding: .utf8)!)
let decodedUpdate = try decoder.decode(Parent.PartialUpdate.self, from: jsonData)

let final = try inital.updated(with: decodedUpdate)

print(final == updated)
