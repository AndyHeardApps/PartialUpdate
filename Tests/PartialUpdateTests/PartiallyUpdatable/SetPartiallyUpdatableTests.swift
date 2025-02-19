import Foundation
import Testing
import PartialUpdateMacros

@Suite("Set PartiallyUpdatable")
struct SetPartiallyUpdatableTests {}

extension SetPartiallyUpdatableTests {

    @Test("No changes")
    func noChanges() throws {
        let value = Set([0, 1])
        #expect(value.update(from: value) == nil)
        try #expect(value.updated(with: nil) == value)
    }

    @Test(
        "Hashable",
        arguments: [
            ("Insert", 1, Set([0, 1, 2]), Set([0, 1, 2, 3])),
            ("Remove", 1, Set([0, 1, 2]), Set([0, 1])),
            ("Insert and remove", 2, Set([0, 1, 2]), Set([1, 3, 0])),
            ("Update", 2, Set([0, 1, 2]), Set([3, 1, 2]))
        ]
    )
    func hashable(
        action: String,
        expectedCount: Int,
        oldValue: Set<Int>,
        newValue: Set<Int>
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
            ("Insert", 1, Set([MockStruct()]), Set([MockStruct(), MockStruct(id: 1)])),
            ("Remove", 1, Set([MockStruct(), MockStruct(id: 1)]), Set([MockStruct()])),
            ("Insert and remove", 2, Set([MockStruct(), MockStruct(id: 1)]), Set([MockStruct(), MockStruct(id: 2)])),
            ("Update", 1, Set([MockStruct(), MockStruct(id: 1)]), Set([MockStruct(), MockStruct(id: 1, optionalInt: 0)]))
        ]
    )
    func identifiable(
        action: String,
        expectedCount: Int,
        oldValue: Set<MockStruct>,
        newValue: Set<MockStruct>
    ) throws {

        let update = newValue.update(from: oldValue)
        #expect(update != nil)
        #expect(update?.count == expectedCount)
        let updated = try oldValue.updated(with: update)
        #expect(newValue == updated)
    }

    @Test("Codable")
    func codable() throws {
        let value1 = Set([MockStruct(), MockStruct(id: 1), MockStruct(id: 2)])
        let value2 = Set([MockStruct(id: 1).mutated(), MockStruct(), MockStruct(id: 3)])

        let update = try #require(value2.update(from: value1))
        let recoded = try value1.recode(update)

        let updated = try value1.updated(with: recoded)
        #expect(updated == value2)
    }
}
