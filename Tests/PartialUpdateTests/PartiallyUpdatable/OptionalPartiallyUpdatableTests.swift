import Foundation
import Testing
import PartialUpdate
import PartialUpdateMacros

@Suite
struct `Optional PartiallyUpdatable` {}

extension `Optional PartiallyUpdatable` {

    @Test
    func `no changes with value`() throws {
        let value: Int? = 1
        #expect(value.update(from: value) == nil)
        try #expect(value.updated(with: nil) == value)
    }

    @Test
    func `no changes with no value`() throws {
        let value: Int? = nil
        #expect(value.update(from: value) == nil)
        try #expect(value.updated(with: nil) == value)
    }

    @Test
    func nullified() throws {
        let value1: Int? = 1
        let value2: Int? = nil
        let update = value2.update(from: value1)
        #expect(update != nil)
        try #expect(value1.updated(with: update) == value2)
    }

    @Test
    func `full value`() throws {
        let value1: Int? = nil
        let value2: Int? = 1
        let update = value2.update(from: value1)
        #expect(update != nil)
        try #expect(value1.updated(with: update) == value2)
    }

    @Test
    func update() throws {
        let value1: Int? = 1
        let value2: Int? = 2
        let update = value2.update(from: value1)
        #expect(update != nil)
        try #expect(value1.updated(with: update) == value2)
    }

    @Test
    func `update nil with partial value`() {

        let value: Int? = nil
        #expect(throws: PartialUpdateError.self) {
            try value.updated(with: .updated(1))
        }
    }
}

// MARK: - Codable
extension `Optional PartiallyUpdatable` {

    @Suite
    struct Codable {

        @Test
        func full() throws {
            let value1: MockStruct? = nil
            let value2: MockStruct? = MockStruct()

            let update = try #require(value2.update(from: value1))
            let recoded = try value1.recode(update)

            let updated = try value1.updated(with: recoded)
            #expect(updated == value2)
        }

        @Test
        func update() throws {
            let value1: MockStruct? = MockStruct()
            let value2: MockStruct? = MockStruct().mutated()

            let update = try #require(value2.update(from: value1))
            let recoded = try value1.recode(update)

            let updated = try value1.updated(with: recoded)
            #expect(updated == value2)
        }

        @Test
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
