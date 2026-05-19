import MacroTesting
import PartialUpdateMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

@Suite(.macros([PartiallyUpdatableMacro.self]))
struct PartialUpdateStructTests {

    @Test
    func `struct expansion`() {

        assertMacro {
            """
            @PartiallyUpdatable
            struct MyStruct {
                let int: Int
                var double: Double?
                var string: String
                var array: [Int?]
                var dictionary: [Int : String]?
            }
            """
        } expansion: {
            """
            struct MyStruct {
                let int: Int
                var double: Double?
                var string: String
                var array: [Int?]
                var dictionary: [Int : String]?
            }
            
            extension MyStruct: PartiallyUpdatable {
            
                struct PartialUpdate {
                    let int: Int.PartialUpdate?
                    let double: Double?.PartialUpdate?
                    let string: String.PartialUpdate?
                    let array: [Int?].PartialUpdate?
                    let dictionary: [Int : String]?.PartialUpdate?
                }
            
                func update(from oldValue: MyStruct) -> PartialUpdate? {
                    guard self != oldValue else {
                        return nil
                    }
                    return PartialUpdate(
                        int: int.update(from: oldValue.int),
                        double: double.update(from: oldValue.double),
                        string: string.update(from: oldValue.string),
                        array: array.update(from: oldValue.array),
                        dictionary: dictionary.update(from: oldValue.dictionary)
                    )
                }
            
                func updated(with partialUpdate: PartialUpdate?) throws -> MyStruct {
                    return try MyStruct(
                        int: int.updated(with: partialUpdate?.int),
                        double: double.updated(with: partialUpdate?.double),
                        string: string.updated(with: partialUpdate?.string),
                        array: array.updated(with: partialUpdate?.array),
                        dictionary: dictionary.updated(with: partialUpdate?.dictionary)
                    )
                }
            }
            """
        }
    }

    @Test
    func `codable inheritance`() {

        assertMacro {
            """
            @PartiallyUpdatable
            struct MyStruct: Codable {
                let int: Int
                var double: Double?
                var string: String
                var array: [Int?]
                var dictionary: [Int : String]?
            }
            """
        } expansion: {
            """
            struct MyStruct: Codable {
                let int: Int
                var double: Double?
                var string: String
                var array: [Int?]
                var dictionary: [Int : String]?
            }
            
            extension MyStruct: PartiallyUpdatable {
            
                struct PartialUpdate: Codable {
                    let int: Int.PartialUpdate?
                    let double: Double?.PartialUpdate?
                    let string: String.PartialUpdate?
                    let array: [Int?].PartialUpdate?
                    let dictionary: [Int : String]?.PartialUpdate?
                }
            
                func update(from oldValue: MyStruct) -> PartialUpdate? {
                    guard self != oldValue else {
                        return nil
                    }
                    return PartialUpdate(
                        int: int.update(from: oldValue.int),
                        double: double.update(from: oldValue.double),
                        string: string.update(from: oldValue.string),
                        array: array.update(from: oldValue.array),
                        dictionary: dictionary.update(from: oldValue.dictionary)
                    )
                }
            
                func updated(with partialUpdate: PartialUpdate?) throws -> MyStruct {
                    return try MyStruct(
                        int: int.updated(with: partialUpdate?.int),
                        double: double.updated(with: partialUpdate?.double),
                        string: string.updated(with: partialUpdate?.string),
                        array: array.updated(with: partialUpdate?.array),
                        dictionary: dictionary.updated(with: partialUpdate?.dictionary)
                    )
                }
            }
            """
        }
    }

    @Test
    func `encodable decodable inheritance`() {

        assertMacro {
            """
            @PartiallyUpdatable
            struct MyStruct: Encodable, Decodable {
                let int: Int
                var double: Double?
                var string: String
                var array: [Int?]
                var dictionary: [Int : String]?
            }
            """
        } expansion: {
            """
            struct MyStruct: Encodable, Decodable {
                let int: Int
                var double: Double?
                var string: String
                var array: [Int?]
                var dictionary: [Int : String]?
            }
            
            extension MyStruct: PartiallyUpdatable {
            
                struct PartialUpdate: Encodable, Decodable {
                    let int: Int.PartialUpdate?
                    let double: Double?.PartialUpdate?
                    let string: String.PartialUpdate?
                    let array: [Int?].PartialUpdate?
                    let dictionary: [Int : String]?.PartialUpdate?
                }
            
                func update(from oldValue: MyStruct) -> PartialUpdate? {
                    guard self != oldValue else {
                        return nil
                    }
                    return PartialUpdate(
                        int: int.update(from: oldValue.int),
                        double: double.update(from: oldValue.double),
                        string: string.update(from: oldValue.string),
                        array: array.update(from: oldValue.array),
                        dictionary: dictionary.update(from: oldValue.dictionary)
                    )
                }
            
                func updated(with partialUpdate: PartialUpdate?) throws -> MyStruct {
                    return try MyStruct(
                        int: int.updated(with: partialUpdate?.int),
                        double: double.updated(with: partialUpdate?.double),
                        string: string.updated(with: partialUpdate?.string),
                        array: array.updated(with: partialUpdate?.array),
                        dictionary: dictionary.updated(with: partialUpdate?.dictionary)
                    )
                }
            }
            """
        }
    }

    @Test
    func `partially updatable inheritance`() {

        assertMacro {
            """
            @PartiallyUpdatable
            struct MyStruct: Encodable, Decodable, PartiallyUpdatable {
                let int: Int
                var double: Double?
                var string: String
                var array: [Int?]
                var dictionary: [Int : String]?
            }
            """
        } expansion: {
            """
            struct MyStruct: Encodable, Decodable, PartiallyUpdatable {
                let int: Int
                var double: Double?
                var string: String
                var array: [Int?]
                var dictionary: [Int : String]?
            }
            
            extension MyStruct {
            
                struct PartialUpdate: Encodable, Decodable {
                    let int: Int.PartialUpdate?
                    let double: Double?.PartialUpdate?
                    let string: String.PartialUpdate?
                    let array: [Int?].PartialUpdate?
                    let dictionary: [Int : String]?.PartialUpdate?
                }
            
                func update(from oldValue: MyStruct) -> PartialUpdate? {
                    guard self != oldValue else {
                        return nil
                    }
                    return PartialUpdate(
                        int: int.update(from: oldValue.int),
                        double: double.update(from: oldValue.double),
                        string: string.update(from: oldValue.string),
                        array: array.update(from: oldValue.array),
                        dictionary: dictionary.update(from: oldValue.dictionary)
                    )
                }
            
                func updated(with partialUpdate: PartialUpdate?) throws -> MyStruct {
                    return try MyStruct(
                        int: int.updated(with: partialUpdate?.int),
                        double: double.updated(with: partialUpdate?.double),
                        string: string.updated(with: partialUpdate?.string),
                        array: array.updated(with: partialUpdate?.array),
                        dictionary: dictionary.updated(with: partialUpdate?.dictionary)
                    )
                }
            }
            """
        }
    }

    @Test
    func `public access modifier`() {

        assertMacro {
            """
            @PartiallyUpdatable
            public struct MyStruct {
                public let int: Int
                public var double: Double?
                public var string: String
                public var array: [Int?]
                var dictionary: [Int : String]?
            }
            """
        } expansion: {
            """
            public struct MyStruct {
                public let int: Int
                public var double: Double?
                public var string: String
                public var array: [Int?]
                var dictionary: [Int : String]?
            }
            
            extension MyStruct: PartiallyUpdatable {
            
                public struct PartialUpdate {
                    public let int: Int.PartialUpdate?
                    public let double: Double?.PartialUpdate?
                    public let string: String.PartialUpdate?
                    public let array: [Int?].PartialUpdate?
                    public let dictionary: [Int : String]?.PartialUpdate?
                }
            
                public func update(from oldValue: MyStruct) -> PartialUpdate? {
                    guard self != oldValue else {
                        return nil
                    }
                    return PartialUpdate(
                        int: int.update(from: oldValue.int),
                        double: double.update(from: oldValue.double),
                        string: string.update(from: oldValue.string),
                        array: array.update(from: oldValue.array),
                        dictionary: dictionary.update(from: oldValue.dictionary)
                    )
                }
            
                public func updated(with partialUpdate: PartialUpdate?) throws -> MyStruct {
                    return try MyStruct(
                        int: int.updated(with: partialUpdate?.int),
                        double: double.updated(with: partialUpdate?.double),
                        string: string.updated(with: partialUpdate?.string),
                        array: array.updated(with: partialUpdate?.array),
                        dictionary: dictionary.updated(with: partialUpdate?.dictionary)
                    )
                }
            }
            """
        }
    }
    
    @Test
    func `package access modifier`() {

        assertMacro {
            """
            @PartiallyUpdatable
            package struct MyStruct {
                package let int: Int
                package var double: Double?
                package var string: String
                package var array: [Int?]
                var dictionary: [Int : String]?
            }
            """
        } expansion: {
            """
            package struct MyStruct {
                package let int: Int
                package var double: Double?
                package var string: String
                package var array: [Int?]
                var dictionary: [Int : String]?
            }

            extension MyStruct: PartiallyUpdatable {

                package struct PartialUpdate {
                    package let int: Int.PartialUpdate?
                    package let double: Double?.PartialUpdate?
                    package let string: String.PartialUpdate?
                    package let array: [Int?].PartialUpdate?
                    package let dictionary: [Int : String]?.PartialUpdate?
                }

                package func update(from oldValue: MyStruct) -> PartialUpdate? {
                    guard self != oldValue else {
                        return nil
                    }
                    return PartialUpdate(
                        int: int.update(from: oldValue.int),
                        double: double.update(from: oldValue.double),
                        string: string.update(from: oldValue.string),
                        array: array.update(from: oldValue.array),
                        dictionary: dictionary.update(from: oldValue.dictionary)
                    )
                }

                package func updated(with partialUpdate: PartialUpdate?) throws -> MyStruct {
                    return try MyStruct(
                        int: int.updated(with: partialUpdate?.int),
                        double: double.updated(with: partialUpdate?.double),
                        string: string.updated(with: partialUpdate?.string),
                        array: array.updated(with: partialUpdate?.array),
                        dictionary: dictionary.updated(with: partialUpdate?.dictionary)
                    )
                }
            }
            """
        }
    }

    @Test
    func `explicit internal access modifier`() {

        assertMacro {
            """
            @PartiallyUpdatable
            internal struct MyStruct {
                internal let int: Int
                internal var double: Double?
                internal var string: String
                internal var array: [Int?]
                var dictionary: [Int : String]?
            }
            """
        } expansion: {
            """
            internal struct MyStruct {
                internal let int: Int
                internal var double: Double?
                internal var string: String
                internal var array: [Int?]
                var dictionary: [Int : String]?
            }
            
            extension MyStruct: PartiallyUpdatable {
            
                struct PartialUpdate {
                    let int: Int.PartialUpdate?
                    let double: Double?.PartialUpdate?
                    let string: String.PartialUpdate?
                    let array: [Int?].PartialUpdate?
                    let dictionary: [Int : String]?.PartialUpdate?
                }
            
                func update(from oldValue: MyStruct) -> PartialUpdate? {
                    guard self != oldValue else {
                        return nil
                    }
                    return PartialUpdate(
                        int: int.update(from: oldValue.int),
                        double: double.update(from: oldValue.double),
                        string: string.update(from: oldValue.string),
                        array: array.update(from: oldValue.array),
                        dictionary: dictionary.update(from: oldValue.dictionary)
                    )
                }
            
                func updated(with partialUpdate: PartialUpdate?) throws -> MyStruct {
                    return try MyStruct(
                        int: int.updated(with: partialUpdate?.int),
                        double: double.updated(with: partialUpdate?.double),
                        string: string.updated(with: partialUpdate?.string),
                        array: array.updated(with: partialUpdate?.array),
                        dictionary: dictionary.updated(with: partialUpdate?.dictionary)
                    )
                }
            }
            """
        }
    }

    @Test
    func `fileprivate access modifier`() {

        assertMacro {
            """
            @PartiallyUpdatable
            fileprivate struct MyStruct {
                fileprivate let int: Int
                fileprivate var double: Double?
                fileprivate var string: String
                fileprivate var array: [Int?]
                var dictionary: [Int : String]?
            }
            """
        } expansion: {
            """
            fileprivate struct MyStruct {
                fileprivate let int: Int
                fileprivate var double: Double?
                fileprivate var string: String
                fileprivate var array: [Int?]
                var dictionary: [Int : String]?
            }
            
            extension MyStruct: PartiallyUpdatable {
            
                fileprivate struct PartialUpdate {
                    fileprivate let int: Int.PartialUpdate?
                    fileprivate let double: Double?.PartialUpdate?
                    fileprivate let string: String.PartialUpdate?
                    fileprivate let array: [Int?].PartialUpdate?
                    fileprivate let dictionary: [Int : String]?.PartialUpdate?
                }
            
                fileprivate func update(from oldValue: MyStruct) -> PartialUpdate? {
                    guard self != oldValue else {
                        return nil
                    }
                    return PartialUpdate(
                        int: int.update(from: oldValue.int),
                        double: double.update(from: oldValue.double),
                        string: string.update(from: oldValue.string),
                        array: array.update(from: oldValue.array),
                        dictionary: dictionary.update(from: oldValue.dictionary)
                    )
                }
            
                fileprivate func updated(with partialUpdate: PartialUpdate?) throws -> MyStruct {
                    return try MyStruct(
                        int: int.updated(with: partialUpdate?.int),
                        double: double.updated(with: partialUpdate?.double),
                        string: string.updated(with: partialUpdate?.string),
                        array: array.updated(with: partialUpdate?.array),
                        dictionary: dictionary.updated(with: partialUpdate?.dictionary)
                    )
                }
            }
            """
        }
    }

    @Test
    func `private access modifier`() {

        assertMacro {
            """
            @PartiallyUpdatable
            private struct MyStruct {
                private let int: Int
                private var double: Double?
                private var string: String
                private var array: [Int?]
                var dictionary: [Int : String]?
            }
            """
        } expansion: {
            """
            private struct MyStruct {
                private let int: Int
                private var double: Double?
                private var string: String
                private var array: [Int?]
                var dictionary: [Int : String]?
            }
            
            extension MyStruct: PartiallyUpdatable {
            
                fileprivate struct PartialUpdate {
                    fileprivate let int: Int.PartialUpdate?
                    fileprivate let double: Double?.PartialUpdate?
                    fileprivate let string: String.PartialUpdate?
                    fileprivate let array: [Int?].PartialUpdate?
                    fileprivate let dictionary: [Int : String]?.PartialUpdate?
                }
            
                fileprivate func update(from oldValue: MyStruct) -> PartialUpdate? {
                    guard self != oldValue else {
                        return nil
                    }
                    return PartialUpdate(
                        int: int.update(from: oldValue.int),
                        double: double.update(from: oldValue.double),
                        string: string.update(from: oldValue.string),
                        array: array.update(from: oldValue.array),
                        dictionary: dictionary.update(from: oldValue.dictionary)
                    )
                }
            
                fileprivate func updated(with partialUpdate: PartialUpdate?) throws -> MyStruct {
                    return try MyStruct(
                        int: int.updated(with: partialUpdate?.int),
                        double: double.updated(with: partialUpdate?.double),
                        string: string.updated(with: partialUpdate?.string),
                        array: array.updated(with: partialUpdate?.array),
                        dictionary: dictionary.updated(with: partialUpdate?.dictionary)
                    )
                }
            }
            """
        }
    }

    @Test
    func `ignored property`() {

        assertMacro {
            """
            @PartiallyUpdatable
            struct MyStruct {
                let int: Int
                var double: Double?
                var string: String
                var array: [Int?]
                @PartiallyUpdatableIgnored
                var dictionary: [Int : String]?
            }
            """
        } expansion: {
            """
            struct MyStruct {
                let int: Int
                var double: Double?
                var string: String
                var array: [Int?]
                @PartiallyUpdatableIgnored
                var dictionary: [Int : String]?
            }
            
            extension MyStruct: PartiallyUpdatable {
            
                struct PartialUpdate {
                    let int: Int.PartialUpdate?
                    let double: Double?.PartialUpdate?
                    let string: String.PartialUpdate?
                    let array: [Int?].PartialUpdate?
                }
            
                func update(from oldValue: MyStruct) -> PartialUpdate? {
                    guard self != oldValue else {
                        return nil
                    }
                    return PartialUpdate(
                        int: int.update(from: oldValue.int),
                        double: double.update(from: oldValue.double),
                        string: string.update(from: oldValue.string),
                        array: array.update(from: oldValue.array)
                    )
                }
            
                func updated(with partialUpdate: PartialUpdate?) throws -> MyStruct {
                    return try MyStruct(
                        int: int.updated(with: partialUpdate?.int),
                        double: double.updated(with: partialUpdate?.double),
                        string: string.updated(with: partialUpdate?.string),
                        array: array.updated(with: partialUpdate?.array),
                        dictionary: dictionary
                    )
                }
            }
            """
        }
    }

    @Test
    func `omitted property`() {

        assertMacro {
            """
            @PartiallyUpdatable
            struct MyStruct {
                let int: Int
                var double: Double?
                var string: String
                var array: [Int?]
                @PartiallyUpdatableOmitted
                var dictionary: [Int : String]?
            }
            """
        } expansion: {
            """
            struct MyStruct {
                let int: Int
                var double: Double?
                var string: String
                var array: [Int?]
                @PartiallyUpdatableOmitted
                var dictionary: [Int : String]?
            }
            
            extension MyStruct: PartiallyUpdatable {
            
                struct PartialUpdate {
                    let int: Int.PartialUpdate?
                    let double: Double?.PartialUpdate?
                    let string: String.PartialUpdate?
                    let array: [Int?].PartialUpdate?
                }
            
                func update(from oldValue: MyStruct) -> PartialUpdate? {
                    guard self != oldValue else {
                        return nil
                    }
                    return PartialUpdate(
                        int: int.update(from: oldValue.int),
                        double: double.update(from: oldValue.double),
                        string: string.update(from: oldValue.string),
                        array: array.update(from: oldValue.array)
                    )
                }
            
                func updated(with partialUpdate: PartialUpdate?) throws -> MyStruct {
                    return try MyStruct(
                        int: int.updated(with: partialUpdate?.int),
                        double: double.updated(with: partialUpdate?.double),
                        string: string.updated(with: partialUpdate?.string),
                        array: array.updated(with: partialUpdate?.array)
                    )
                }
            }
            """
        }
    }

    @Test
    func `ignore computed property`() {

        assertMacro {
            """
            @PartiallyUpdatable
            struct MyStruct {
                let int: Int
                var double: Double?
                var string: String
                var array: [Int?]
                var dictionary: [Int : String]? {
                    [:]
                }
            }
            """
        } expansion: {
            """
            struct MyStruct {
                let int: Int
                var double: Double?
                var string: String
                var array: [Int?]
                var dictionary: [Int : String]? {
                    [:]
                }
            }
            
            extension MyStruct: PartiallyUpdatable {
            
                struct PartialUpdate {
                    let int: Int.PartialUpdate?
                    let double: Double?.PartialUpdate?
                    let string: String.PartialUpdate?
                    let array: [Int?].PartialUpdate?
                }
            
                func update(from oldValue: MyStruct) -> PartialUpdate? {
                    guard self != oldValue else {
                        return nil
                    }
                    return PartialUpdate(
                        int: int.update(from: oldValue.int),
                        double: double.update(from: oldValue.double),
                        string: string.update(from: oldValue.string),
                        array: array.update(from: oldValue.array)
                    )
                }
            
                func updated(with partialUpdate: PartialUpdate?) throws -> MyStruct {
                    return try MyStruct(
                        int: int.updated(with: partialUpdate?.int),
                        double: double.updated(with: partialUpdate?.double),
                        string: string.updated(with: partialUpdate?.string),
                        array: array.updated(with: partialUpdate?.array)
                    )
                }
            }
            """
        }
    }

    @Test
    func `ignore computed get set property`() {

        assertMacro {
            """
            @PartiallyUpdatable
            struct MyStruct {
                let int: Int
                var double: Double?
                var string: String
                var array: [Int?]
                var dictionary: [Int : String]? {
                    get {
                        [:]
                    }
                    set {
                    
                    }
                }
            }
            """
        } expansion: {
            """
            struct MyStruct {
                let int: Int
                var double: Double?
                var string: String
                var array: [Int?]
                var dictionary: [Int : String]? {
                    get {
                        [:]
                    }
                    set {
                    
                    }
                }
            }
            
            extension MyStruct: PartiallyUpdatable {
            
                struct PartialUpdate {
                    let int: Int.PartialUpdate?
                    let double: Double?.PartialUpdate?
                    let string: String.PartialUpdate?
                    let array: [Int?].PartialUpdate?
                }
            
                func update(from oldValue: MyStruct) -> PartialUpdate? {
                    guard self != oldValue else {
                        return nil
                    }
                    return PartialUpdate(
                        int: int.update(from: oldValue.int),
                        double: double.update(from: oldValue.double),
                        string: string.update(from: oldValue.string),
                        array: array.update(from: oldValue.array)
                    )
                }
            
                func updated(with partialUpdate: PartialUpdate?) throws -> MyStruct {
                    return try MyStruct(
                        int: int.updated(with: partialUpdate?.int),
                        double: double.updated(with: partialUpdate?.double),
                        string: string.updated(with: partialUpdate?.string),
                        array: array.updated(with: partialUpdate?.array)
                    )
                }
            }
            """
        }
    }

    @Test
    func `no type annotation`() {
        
        assertMacro {
            """
            @PartiallyUpdatable
            struct MyStruct {
                let int = 1
                var double: Double?
                var string: String
                var array: [Int?]
                var dictionary: [Int : String]?
            }
            """
        } diagnostics: {
            """
            @PartiallyUpdatable
            struct MyStruct {
                let int = 1
                    ┬──────
                    ╰─ ⚠️ Property must include a type annotation to be included in "@PartiallyUpdatable" macro.
                var double: Double?
                var string: String
                var array: [Int?]
                var dictionary: [Int : String]?
            }
            """
        } expansion: {
            """
            struct MyStruct {
                let int = 1
                var double: Double?
                var string: String
                var array: [Int?]
                var dictionary: [Int : String]?
            }

            extension MyStruct: PartiallyUpdatable {

                struct PartialUpdate {
                    let double: Double?.PartialUpdate?
                    let string: String.PartialUpdate?
                    let array: [Int?].PartialUpdate?
                    let dictionary: [Int : String]?.PartialUpdate?
                }

                func update(from oldValue: MyStruct) -> PartialUpdate? {
                    guard self != oldValue else {
                        return nil
                    }
                    return PartialUpdate(
                        double: double.update(from: oldValue.double),
                        string: string.update(from: oldValue.string),
                        array: array.update(from: oldValue.array),
                        dictionary: dictionary.update(from: oldValue.dictionary)
                    )
                }

                func updated(with partialUpdate: PartialUpdate?) throws -> MyStruct {
                    return try MyStruct(
                        double: double.updated(with: partialUpdate?.double),
                        string: string.updated(with: partialUpdate?.string),
                        array: array.updated(with: partialUpdate?.array),
                        dictionary: dictionary.updated(with: partialUpdate?.dictionary)
                    )
                }
            }
            """
        }
    }
}
