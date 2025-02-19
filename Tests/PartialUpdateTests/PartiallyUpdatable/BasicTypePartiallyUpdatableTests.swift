import Foundation
import Testing
import PartialUpdateMacros

@Suite("Basic type PartiallyUpdatable")
struct BasicTypePartiallyUpdatableTests {}

// MARK: - No changes
extension BasicTypePartiallyUpdatableTests {

    @Suite("No changes")
    struct NoChanges {

        @Test("Int")
        func int() {
            let value = Int(0)
            #expect(value.update(from: value) == nil)
        }

        @Test("UInt")
        func uint() {
            let value = UInt(0)
            #expect(value.update(from: value) == nil)
        }

        @Test("Int8")
        func int8() {
            let value = Int8(0)
            #expect(value.update(from: value) == nil)
        }

        @Test("UInt8")
        func uint8() {
            let value = UInt8(0)
            #expect(value.update(from: value) == nil)
        }

        @Test("Int16")
        func int16() {
            let value = Int16(0)
            #expect(value.update(from: value) == nil)
        }

        @Test("UInt16")
        func uint16() {
            let value = UInt16(0)
            #expect(value.update(from: value) == nil)
        }

        @Test("Int32")
        func int32() {
            let value = Int32(0)
            #expect(value.update(from: value) == nil)
        }

        @Test("UInt32")
        func uint32() {
            let value = UInt32(0)
            #expect(value.update(from: value) == nil)
        }

        @Test("Int64")
        func int64() {
            let value = Int64(0)
            #expect(value.update(from: value) == nil)
        }

        @Test("UInt64")
        func uint64() {
            let value = UInt64(0)
            #expect(value.update(from: value) == nil)
        }

        @available(macOS 15.0, *)
        @Test("Int128")
        func int128() {
            let value = Int128(0)
            #expect(value.update(from: value) == nil)
        }

        @available(macOS 15.0, *)
        @Test("UInt128")
        func uint128() {
            let value = UInt128(0)
            #expect(value.update(from: value) == nil)
        }

        @Test("Double")
        func double() {
            let value = Double(0)
            #expect(value.update(from: value) == nil)
        }

        @Test("Float")
        func float() {
            let value = Float(0)
            #expect(value.update(from: value) == nil)
        }

        @Test("Bool")
        func bool() {
            let value = false
            #expect(value.update(from: value) == nil)
        }

        @Test("String")
        func string() {
            let value = ""
            #expect(value.update(from: value) == nil)
        }

        @Test("UUID")
        func uuid() {
            let value = UUID()
            #expect(value.update(from: value) == nil)
        }

        @Test("Date")
        func date() {
            let value = Date()
            #expect(value.update(from: value) == nil)
        }
    }
}

// MARK: - With changes
extension BasicTypePartiallyUpdatableTests {

    @Suite("With changes")
    struct WithChanges {

        @Test("Int")
        func int() {
            let value1 = Int(0)
            let value2 = Int(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test("UInt")
        func uint() {
            let value1 = UInt(0)
            let value2 = UInt(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test("Int8")
        func int8() {
            let value1 = Int8(0)
            let value2 = Int8(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test("UInt8")
        func uint8() {
            let value1 = UInt8(0)
            let value2 = UInt8(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test("Int16")
        func int16() {
            let value1 = Int16(0)
            let value2 = Int16(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test("UInt16")
        func uint16() {
            let value1 = UInt16(0)
            let value2 = UInt16(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test("Int32")
        func int32() {
            let value1 = Int32(0)
            let value2 = Int32(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test("UInt32")
        func uint32() {
            let value1 = UInt32(0)
            let value2 = UInt32(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test("Int64")
        func int64() {
            let value1 = Int64(0)
            let value2 = Int64(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test("UInt64")
        func uint64() {
            let value1 = UInt64(0)
            let value2 = UInt64(1)
            #expect(value2.update(from: value1) == value2)
        }

        @available(macOS 15.0, *)
        @Test("Int128")
        func int128() {
            let value1 = Int128(0)
            let value2 = Int128(1)
            #expect(value2.update(from: value1) == value2)
        }

        @available(macOS 15.0, *)
        @Test("UInt128")
        func uint128() {
            let value1 = UInt128(0)
            let value2 = UInt128(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test("Double")
        func double() {
            let value1 = Double(0)
            let value2 = Double(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test("Float")
        func float() {
            let value1 = Float(0)
            let value2 = Float(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test("Bool")
        func bool() {
            let value1 = false
            let value2 = true
            #expect(value2.update(from: value1) == value2)
        }

        @Test("String")
        func string() {
            let value1 = ""
            let value2 = "1"
            #expect(value2.update(from: value1) == value2)
        }

        @Test("UUID")
        func uuid() {
            let value1 = UUID()
            let value2 = UUID()
            #expect(value2.update(from: value1) == value2)
        }

        @Test("Date")
        func date() {
            let value1 = Date()
            let value2 = value1.addingTimeInterval(1)
            #expect(value2.update(from: value1) == value2)
        }
    }
}

// MARK: - Nil update
extension BasicTypePartiallyUpdatableTests {

    @Suite("Nil update")
    struct NilUpdate {

        @Test("Int")
        func int() throws {
            let value = Int(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test("UInt")
        func uint() throws {
            let value = UInt(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test("Int8")
        func int8() throws {
            let value = Int8(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test("UInt8")
        func uint8() throws {
            let value = UInt8(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test("Int16")
        func int16() throws {
            let value = Int16(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test("UInt16")
        func uint16() throws {
            let value = UInt16(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test("Int32")
        func int32() throws {
            let value = Int32(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test("UInt32")
        func uint32() throws {
            let value = UInt32(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test("Int64")
        func int64() throws {
            let value = Int64(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test("UInt64")
        func uint64() throws {
            let value = UInt64(0)
            try #expect(value.updated(with: nil) == value)
        }

        @available(macOS 15.0, *)
        @Test("Int128")
        func int128() throws {
            let value = Int128(0)
            try #expect(value.updated(with: nil) == value)
        }

        @available(macOS 15.0, *)
        @Test("UInt128")
        func uint128() throws {
            let value = UInt128(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test("Double")
        func double() throws {
            let value = Double(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test("Float")
        func float() throws {
            let value = Float(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test("Bool")
        func bool() throws {
            let value = false
            try #expect(value.updated(with: nil) == value)
        }

        @Test("String")
        func string() throws {
            let value = ""
            try #expect(value.updated(with: nil) == value)
        }

        @Test("UUID")
        func uuid() throws {
            let value = UUID()
            try #expect(value.updated(with: nil) == value)
        }

        @Test("Date")
        func date() throws {
            let value = Date()
            try #expect(value.updated(with: nil) == value)
        }
    }
}

// MARK: - Non nil update
extension BasicTypePartiallyUpdatableTests {

    @Suite("Non nil update")
    struct NonNilUpdate {

        @Test("Int")
        func int() throws {
            let value1 = Int(0)
            let value2 = Int(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test("UInt")
        func uint() throws {
            let value1 = UInt(0)
            let value2 = UInt(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test("Int8")
        func int8() throws {
            let value1 = Int8(0)
            let value2 = Int8(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test("UInt8")
        func uint8() throws {
            let value1 = UInt8(0)
            let value2 = UInt8(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test("Int16")
        func int16() throws {
            let value1 = Int16(0)
            let value2 = Int16(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test("UInt16")
        func uint16() throws {
            let value1 = UInt16(0)
            let value2 = UInt16(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test("Int32")
        func int32() throws {
            let value1 = Int32(0)
            let value2 = Int32(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test("UInt32")
        func uint32() throws {
            let value1 = UInt32(0)
            let value2 = UInt32(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test("Int64")
        func int64() throws {
            let value1 = Int64(0)
            let value2 = Int64(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test("UInt64")
        func uint64() throws {
            let value1 = UInt64(0)
            let value2 = UInt64(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @available(macOS 15.0, *)
        @Test("Int128")
        func int128() throws {
            let value1 = Int128(0)
            let value2 = Int128(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @available(macOS 15.0, *)
        @Test("UInt128")
        func uint128() throws {
            let value1 = UInt128(0)
            let value2 = UInt128(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test("Double")
        func double() throws {
            let value1 = Double(0)
            let value2 = Double(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test("Float")
        func float() throws {
            let value1 = Float(0)
            let value2 = Float(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test("Bool")
        func bool() throws {
            let value1 = false
            let value2 = true
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test("String")
        func string() throws {
            let value1 = ""
            let value2 = "1"
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test("UUID")
        func uuid() throws {
            let value1 = UUID()
            let value2 = UUID()
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test("Date")
        func date() throws {
            let value1 = Date()
            let value2 = value1.addingTimeInterval(1)
            try #expect(value2.updated(with: value1) == value1)
        }
    }
}
