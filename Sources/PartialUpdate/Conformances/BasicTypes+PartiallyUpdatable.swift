import Foundation

extension Int: PartiallyUpdatable {

    public func updated(with partialUpdate: Int?) throws -> Int {
        partialUpdate ?? self
    }

    public func update(from oldValue: Int) -> Int? {
        oldValue == self ? nil : self
    }
}

@available(macOS 15.0, *)
extension Int128: PartiallyUpdatable {

    public func updated(with partialUpdate: Int128?) throws -> Int128 {
        partialUpdate ?? self
    }

    public func update(from oldValue: Int128) -> Int128? {
        oldValue == self ? nil : self
    }
}

extension Int64: PartiallyUpdatable {

    public func updated(with partialUpdate: Int64?) throws -> Int64 {
        partialUpdate ?? self
    }

    public func update(from oldValue: Int64) -> Int64? {
        oldValue == self ? nil : self
    }
}

extension Int32: PartiallyUpdatable {

    public func updated(with partialUpdate: Int32?) throws -> Int32 {
        partialUpdate ?? self
    }

    public func update(from oldValue: Int32) -> Int32? {
        oldValue == self ? nil : self
    }
}

extension Int16: PartiallyUpdatable {

    public func updated(with partialUpdate: Int16?) throws -> Int16 {
        partialUpdate ?? self
    }

    public func update(from oldValue: Int16) -> Int16? {
        oldValue == self ? nil : self
    }
}

extension Int8: PartiallyUpdatable {

    public func updated(with partialUpdate: Int8?) throws -> Int8 {
        partialUpdate ?? self
    }

    public func update(from oldValue: Int8) -> Int8? {
        oldValue == self ? nil : self
    }
}

extension UInt: PartiallyUpdatable {

    public func updated(with partialUpdate: UInt?) throws -> UInt {
        partialUpdate ?? self
    }

    public func update(from oldValue: UInt) -> UInt? {
        oldValue == self ? nil : self
    }
}

@available(macOS 15.0, *)
extension UInt128: PartiallyUpdatable {

    public func updated(with partialUpdate: UInt128?) throws -> UInt128 {
        partialUpdate ?? self
    }

    public func update(from oldValue: UInt128) -> UInt128? {
        oldValue == self ? nil : self
    }
}

extension UInt64: PartiallyUpdatable {

    public func updated(with partialUpdate: UInt64?) throws -> UInt64 {
        partialUpdate ?? self
    }

    public func update(from oldValue: UInt64) -> UInt64? {
        oldValue == self ? nil : self
    }
}

extension UInt32: PartiallyUpdatable {

    public func updated(with partialUpdate: UInt32?) throws -> UInt32 {
        partialUpdate ?? self
    }

    public func update(from oldValue: UInt32) -> UInt32? {
        oldValue == self ? nil : self
    }
}

extension UInt16: PartiallyUpdatable {

    public func updated(with partialUpdate: UInt16?) throws -> UInt16 {
        partialUpdate ?? self
    }

    public func update(from oldValue: UInt16) -> UInt16? {
        oldValue == self ? nil : self
    }
}

extension UInt8: PartiallyUpdatable {

    public func updated(with partialUpdate: UInt8?) throws -> UInt8 {
        partialUpdate ?? self
    }

    public func update(from oldValue: UInt8) -> UInt8? {
        oldValue == self ? nil : self
    }
}

extension Double: PartiallyUpdatable {

    public func updated(with partialUpdate: Double?) throws -> Double {
        partialUpdate ?? self
    }

    public func update(from oldValue: Double) -> Double? {
        oldValue == self ? nil : self
    }
}

extension Float: PartiallyUpdatable {

    public func updated(with partialUpdate: Float?) throws -> Float {
        partialUpdate ?? self
    }

    public func update(from oldValue: Float) -> Float? {
        oldValue == self ? nil : self
    }
}

extension Bool: PartiallyUpdatable {

    public func updated(with partialUpdate: Bool?) throws -> Bool {
        partialUpdate ?? self
    }

    public func update(from oldValue: Bool) -> Bool? {
        oldValue == self ? nil : self
    }
}

extension String: PartiallyUpdatable {

    public func updated(with partialUpdate: String?) throws -> String {
        partialUpdate ?? self
    }

    public func update(from oldValue: String) -> String? {
        oldValue == self ? nil : self
    }
}

extension Date: PartiallyUpdatable {

    public func updated(with partialUpdate: Date?) throws -> Date {
        partialUpdate ?? self
    }

    public func update(from oldValue: Date) -> Date? {
        oldValue == self ? nil : self
    }
}

extension UUID: PartiallyUpdatable {

    public func updated(with partialUpdate: UUID?) throws -> UUID {
        partialUpdate ?? self
    }

    public func update(from oldValue: UUID) -> UUID? {
        oldValue == self ? nil : self
    }
}
