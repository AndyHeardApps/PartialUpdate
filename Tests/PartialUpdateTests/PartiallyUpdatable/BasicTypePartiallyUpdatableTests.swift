import Foundation
import Testing
import PartialUpdateMacros

@Suite
struct `Basic type PartiallyUpdatable` {}

// MARK: - No changes
extension `Basic type PartiallyUpdatable` {

    @Suite
    struct `No changes` {

        @Test
        func int() {
            let value = Int(0)
            #expect(value.update(from: value) == nil)
        }

        @Test
        func uint() {
            let value = UInt(0)
            #expect(value.update(from: value) == nil)
        }

        @Test
        func int8() {
            let value = Int8(0)
            #expect(value.update(from: value) == nil)
        }

        @Test
        func uint8() {
            let value = UInt8(0)
            #expect(value.update(from: value) == nil)
        }

        @Test
        func int16() {
            let value = Int16(0)
            #expect(value.update(from: value) == nil)
        }

        @Test
        func uint16() {
            let value = UInt16(0)
            #expect(value.update(from: value) == nil)
        }

        @Test
        func int32() {
            let value = Int32(0)
            #expect(value.update(from: value) == nil)
        }

        @Test
        func uint32() {
            let value = UInt32(0)
            #expect(value.update(from: value) == nil)
        }

        @Test
        func int64() {
            let value = Int64(0)
            #expect(value.update(from: value) == nil)
        }

        @Test
        func uint64() {
            let value = UInt64(0)
            #expect(value.update(from: value) == nil)
        }

        @available(macOS 15.0, *)
        @Test
        func int128() {
            let value = Int128(0)
            #expect(value.update(from: value) == nil)
        }

        @available(macOS 15.0, *)
        @Test
        func uint128() {
            let value = UInt128(0)
            #expect(value.update(from: value) == nil)
        }

        @Test
        func double() {
            let value = Double(0)
            #expect(value.update(from: value) == nil)
        }

        @Test
        func float() {
            let value = Float(0)
            #expect(value.update(from: value) == nil)
        }

        @Test
        func bool() {
            let value = false
            #expect(value.update(from: value) == nil)
        }

        @Test
        func string() {
            let value = ""
            #expect(value.update(from: value) == nil)
        }

        @Test
        func uuid() {
            let value = UUID()
            #expect(value.update(from: value) == nil)
        }

        @Test
        func date() {
            let value = Date()
            #expect(value.update(from: value) == nil)
        }
    }
}

// MARK: - With changes
extension `Basic type PartiallyUpdatable` {

    @Suite
    struct `With changes` {

        @Test
        func int() {
            let value1 = Int(0)
            let value2 = Int(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test
        func uint() {
            let value1 = UInt(0)
            let value2 = UInt(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test
        func int8() {
            let value1 = Int8(0)
            let value2 = Int8(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test
        func uint8() {
            let value1 = UInt8(0)
            let value2 = UInt8(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test
        func int16() {
            let value1 = Int16(0)
            let value2 = Int16(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test
        func uint16() {
            let value1 = UInt16(0)
            let value2 = UInt16(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test
        func int32() {
            let value1 = Int32(0)
            let value2 = Int32(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test
        func uint32() {
            let value1 = UInt32(0)
            let value2 = UInt32(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test
        func int64() {
            let value1 = Int64(0)
            let value2 = Int64(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test
        func uint64() {
            let value1 = UInt64(0)
            let value2 = UInt64(1)
            #expect(value2.update(from: value1) == value2)
        }

        @available(macOS 15.0, *)
        @Test
        func int128() {
            let value1 = Int128(0)
            let value2 = Int128(1)
            #expect(value2.update(from: value1) == value2)
        }

        @available(macOS 15.0, *)
        @Test
        func uint128() {
            let value1 = UInt128(0)
            let value2 = UInt128(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test
        func double() {
            let value1 = Double(0)
            let value2 = Double(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test
        func float() {
            let value1 = Float(0)
            let value2 = Float(1)
            #expect(value2.update(from: value1) == value2)
        }

        @Test
        func bool() {
            let value1 = false
            let value2 = true
            #expect(value2.update(from: value1) == value2)
        }

        @Test
        func string() {
            let value1 = ""
            let value2 = "1"
            #expect(value2.update(from: value1) == value2)
        }

        @Test
        func uuid() {
            let value1 = UUID()
            let value2 = UUID()
            #expect(value2.update(from: value1) == value2)
        }

        @Test
        func date() {
            let value1 = Date()
            let value2 = value1.addingTimeInterval(1)
            #expect(value2.update(from: value1) == value2)
        }
    }
}

// MARK: - Nil update
extension `Basic type PartiallyUpdatable` {

    @Suite
    struct `Nil update` {

        @Test
        func int() throws {
            let value = Int(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test
        func uint() throws {
            let value = UInt(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test
        func int8() throws {
            let value = Int8(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test
        func uint8() throws {
            let value = UInt8(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test
        func int16() throws {
            let value = Int16(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test
        func uint16() throws {
            let value = UInt16(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test
        func int32() throws {
            let value = Int32(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test
        func uint32() throws {
            let value = UInt32(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test
        func int64() throws {
            let value = Int64(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test
        func uint64() throws {
            let value = UInt64(0)
            try #expect(value.updated(with: nil) == value)
        }

        @available(macOS 15.0, *)
        @Test
        func int128() throws {
            let value = Int128(0)
            try #expect(value.updated(with: nil) == value)
        }

        @available(macOS 15.0, *)
        @Test
        func uint128() throws {
            let value = UInt128(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test
        func double() throws {
            let value = Double(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test
        func float() throws {
            let value = Float(0)
            try #expect(value.updated(with: nil) == value)
        }

        @Test
        func bool() throws {
            let value = false
            try #expect(value.updated(with: nil) == value)
        }

        @Test
        func string() throws {
            let value = ""
            try #expect(value.updated(with: nil) == value)
        }

        @Test
        func uuid() throws {
            let value = UUID()
            try #expect(value.updated(with: nil) == value)
        }

        @Test
        func date() throws {
            let value = Date()
            try #expect(value.updated(with: nil) == value)
        }
    }
}

// MARK: - Non nil update
extension `Basic type PartiallyUpdatable` {

    @Suite
    struct `Non nil update` {

        @Test
        func int() throws {
            let value1 = Int(0)
            let value2 = Int(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test
        func uint() throws {
            let value1 = UInt(0)
            let value2 = UInt(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test
        func int8() throws {
            let value1 = Int8(0)
            let value2 = Int8(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test
        func uint8() throws {
            let value1 = UInt8(0)
            let value2 = UInt8(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test
        func int16() throws {
            let value1 = Int16(0)
            let value2 = Int16(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test
        func uint16() throws {
            let value1 = UInt16(0)
            let value2 = UInt16(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test
        func int32() throws {
            let value1 = Int32(0)
            let value2 = Int32(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test
        func uint32() throws {
            let value1 = UInt32(0)
            let value2 = UInt32(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test
        func int64() throws {
            let value1 = Int64(0)
            let value2 = Int64(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test
        func uint64() throws {
            let value1 = UInt64(0)
            let value2 = UInt64(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @available(macOS 15.0, *)
        @Test
        func int128() throws {
            let value1 = Int128(0)
            let value2 = Int128(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @available(macOS 15.0, *)
        @Test
        func uint128() throws {
            let value1 = UInt128(0)
            let value2 = UInt128(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test
        func double() throws {
            let value1 = Double(0)
            let value2 = Double(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test
        func float() throws {
            let value1 = Float(0)
            let value2 = Float(1)
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test
        func bool() throws {
            let value1 = false
            let value2 = true
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test
        func string() throws {
            let value1 = ""
            let value2 = "1"
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test
        func uuid() throws {
            let value1 = UUID()
            let value2 = UUID()
            try #expect(value2.updated(with: value1) == value1)
        }

        @Test
        func date() throws {
            let value1 = Date()
            let value2 = value1.addingTimeInterval(1)
            try #expect(value2.updated(with: value1) == value1)
        }
    }
}
