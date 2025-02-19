import Foundation
import Testing
import PartialUpdate
import PartialUpdateMacros

@Suite("Optional PartiallyUpdatable")
struct OptionalPartiallyUpdatableTests {}

extension OptionalPartiallyUpdatableTests {

    @Test("No changes with value")
    func noChangesWithValue() throws {
        let value: Int? = 1
        #expect(value.update(from: value) == nil)
        try #expect(value.updated(with: nil) == value)
    }

    @Test("No changes with no value")
    func noChangesWithNoValue() throws {
        let value: Int? = nil
        #expect(value.update(from: value) == nil)
        try #expect(value.updated(with: nil) == value)
    }

    @Test("Nullified")
    func nullified() throws {
        let value1: Int? = 1
        let value2: Int? = nil
        let update = value2.update(from: value1)
        #expect(update != nil)
        try #expect(value1.updated(with: update) == value2)
    }

    @Test("Full value")
    func full() throws {
        let value1: Int? = nil
        let value2: Int? = 1
        let update = value2.update(from: value1)
        #expect(update != nil)
        try #expect(value1.updated(with: update) == value2)
    }

    @Test("Update")
    func update() throws {
        let value1: Int? = 1
        let value2: Int? = 2
        let update = value2.update(from: value1)
        #expect(update != nil)
        try #expect(value1.updated(with: update) == value2)
    }

    @Test("Update nil with partial value")
    func updateNilWithPartialValue() {

        let value: Int? = nil
        #expect(throws: PartialUpdateError.self) {
            try value.updated(with: .updated(1))
        }
    }
}

// MARK: - Codable
extension OptionalPartiallyUpdatableTests {

    @Suite("Codable")
    struct Codable {

        @Test("Full")
        func full() throws {
            let value1: MockStruct? = nil
            let value2: MockStruct? = MockStruct()

            let update = try #require(value2.update(from: value1))
            let recoded = try value1.recode(update)

            let updated = try value1.updated(with: recoded)
            #expect(updated == value2)
        }

        @Test("Update")
        func update() throws {
            let value1: MockStruct? = MockStruct()
            let value2: MockStruct? = MockStruct().mutated()

            let update = try #require(value2.update(from: value1))
            let recoded = try value1.recode(update)

            let updated = try value1.updated(with: recoded)
            #expect(updated == value2)
        }

        @Test("Nullified")
        func nullified() throws {
            let value1: MockStruct? = MockStruct()
            let value2: MockStruct? = nil

            let update = try #require(value2.update(from: value1))
            let recoded = try value1.recode(update)

            let updated = try value1.updated(with: recoded)
            #expect(updated == value2)
        }
    }
}
