import Foundation
import Testing
import PartialUpdateMacros

@Suite("Array PartiallyUpdatable")
struct ArrayPartiallyUpdatableTests {}

extension ArrayPartiallyUpdatableTests {

    @Test("No changes")
    func noChanges() throws {
        let value = [0, 1]
        #expect(value.update(from: value) == nil)
        try #expect(value.updated(with: nil) == value)
    }

    @Test(
        "Hashable",
        arguments: [
            ("Insert", 1, [0, 1, 2], [0, 1, 2, 3]),
            ("Remove", 1, [0, 1, 2], [0, 1]),
            ("Insert and remove", 3, [0, 1, 2], [1, 3, 0]),
            ("Update", 1, [0, 1, 2], [1, 1, 2])
        ]
    )
    func hashable(
        action: String,
        expectedCount: Int,
        oldValue: [Int],
        newValue: [Int]
    ) throws {

        let update = newValue.update(from: oldValue)
        #expect(update != nil)
        #expect(update?.count == expectedCount)
        let updated = try oldValue.updated(with: update)
        #expect(newValue == updated)
    }

    @Test(
        "Identifiable",
        arguments: [
            ("Insert", 1, [MockStruct()], [MockStruct(), MockStruct(id: 1)]),
            ("Remove", 1, [MockStruct(), MockStruct(id: 1)], [MockStruct()]),
            ("Insert and remove", 2, [MockStruct(), MockStruct(id: 1)], [MockStruct(), MockStruct(id: 2)]),
            ("Move", 1, [MockStruct(), MockStruct(id: 1)], [MockStruct(id: 1), MockStruct()]),
            ("Update", 1, [MockStruct(), MockStruct(id: 1)], [MockStruct(), MockStruct(id: 1, optionalInt: 0)])
        ]
    )
    func identifiable(
        action: String,
        expectedCount: Int,
        oldValue: [MockStruct],
        newValue: [MockStruct]
    ) throws {

        let update = newValue.update(from: oldValue)
        #expect(update != nil)
        #expect(update?.count == expectedCount)
        let updated = try oldValue.updated(with: update)
        #expect(newValue == updated)
    }

    @Test("Codable")
    func codable() throws {
        let value1 = [MockStruct(), MockStruct(id: 1), MockStruct(id: 2)]
        let value2 = [MockStruct(id: 1).mutated(), MockStruct(), MockStruct(id: 3)]

        let update = try #require(value2.update(from: value1))
        let recoded = try value1.recode(update)

        let updated = try value1.updated(with: recoded)
        #expect(updated == value2)
    }
}
