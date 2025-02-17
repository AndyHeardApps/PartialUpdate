import Foundation
import PartialUpdate

@PartiallyUpdatable
struct Child: Identifiable {

    let id: UUID
    var string: String?
    var int: Int?
    var double: Double
    @PartiallyUpdatableIgnored
    var ignored: UUID

    init(
        id: UUID = .init(),
        string: String? = "string",
        int: Int? = nil,
        double: Double = 5.5,
        ignored: UUID = .init()
    ) {
        self.id = id
        self.string = string
        self.int = int
        self.double = double
        self.ignored = ignored
    }
}

@PartiallyUpdatable
struct Parent {

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
        option: Option = .person(first: "First", nil)
    ) {
        self.bool = bool
        self.array = array
        self.dictionary = dictionary
        self.set = set
        self.option = option
    }
}

@PartiallyUpdatable
enum Option {
    case int(Int)
    case person(first: String, String?)
    case flat
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
updated.option = .person(first: "First", "Second")

let update = updated.update(from: inital)

let decoder = JSONDecoder()
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let jsonData = try encoder.encode(update)
print(String(data: jsonData, encoding: .utf8)!)
let decodedUpdate = try decoder.decode(Parent.PartialUpdate.self, from: jsonData)

let final = try inital.updated(with: decodedUpdate)

print(final == updated)
