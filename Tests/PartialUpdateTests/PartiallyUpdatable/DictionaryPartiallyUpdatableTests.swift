import Foundation
import Testing
import PartialUpdateMacros

@Suite("Dictionary PartiallyUpdatable")
struct DictionaryPartiallyUpdatableTests {}

extension DictionaryPartiallyUpdatableTests {


    @Test("No changes")
    func noChanges() throws {
        let value = [0 : "zero"]
        #expect(value.update(from: value) == nil)
        try #expect(value.updated(with: nil) == value)
    }

    @Test(
        "Hashable",
        arguments: [
            ("Insert", 1, [0 : "zero"], [0 : "zero", 1 : "one"]),
            ("Remove", 1, [0 : "zero", 1 : "one"], [0 : "zero"]),
            ("Insert and remove", 2, [0 : "zero", 1 : "one"], [0 : "zero", 2 : "two"]),
            ("Update", 1, [0 : "zero", 1 : "one"], [0 : "zero", 1 : "One"])
        ]
    )
    func hashable(
        action: String,
        expectedCount: Int,
        oldValue: [Int : String],
        newValue: [Int : String]
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
            ("Insert", 1, [0 : MockStruct()], [0 : MockStruct(), 1 : MockStruct(id: 1)]),
            ("Remove", 1, [0 : MockStruct(), 1 : MockStruct(id: 1)], [0 : MockStruct()]),
            ("Insert and remove", 2, [0 : MockStruct(), 1 : MockStruct(id: 1)], [0 : MockStruct(), 2 : MockStruct(id: 2)]),
            ("Update", 1, [0 : MockStruct(), 1 : MockStruct(id: 1)], [0 : MockStruct(), 1 : MockStruct(id: 1, optionalInt: 0)])
        ]
    )
    func identifiable(
        action: String,
        expectedCount: Int,
        oldValue: [Int : MockStruct],
        newValue: [Int : MockStruct]
    ) throws {

        let update = newValue.update(from: oldValue)
        #expect(update != nil)
        #expect(update?.count == expectedCount)
        let updated = try oldValue.updated(with: update)
        #expect(newValue == updated)
    }

    @Test("Codable")
    func codable() throws {
        let value1 = [0 : MockStruct(), 1 : MockStruct(id: 1), 2 : MockStruct(id: 2)]
        let value2 = [1 : MockStruct(id: 1).mutated(), 0 : MockStruct(), 3 : MockStruct(id: 3)]

        let update = try #require(value2.update(from: value1))
        let recoded = try value1.recode(update)

        let updated = try value1.updated(with: recoded)
        #expect(updated == value2)
    }
}
