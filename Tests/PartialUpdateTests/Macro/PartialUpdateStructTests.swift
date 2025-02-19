import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class PartialUpdateStructTests: XCTestCase {

    func test_structExpansion() throws {

        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @PartiallyUpdatable
        struct MyStruct {
            let int: Int
            var double: Double?
            var string: String
            var array: [Int?]
            var dictionary: [Int : String]?
        }
        """,
        expandedSource: """
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
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_codableInheritance() throws {

        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @PartiallyUpdatable
        struct MyStruct: Codable {
            let int: Int
            var double: Double?
            var string: String
            var array: [Int?]
            var dictionary: [Int : String]?
        }
        """,
        expandedSource: """
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
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_encodableDecodableInheritance() throws {

        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @PartiallyUpdatable
        struct MyStruct: Encodable, Decodable {
            let int: Int
            var double: Double?
            var string: String
            var array: [Int?]
            var dictionary: [Int : String]?
        }
        """,
        expandedSource: """
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
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_partiallyUpdatableInheritance() throws {

        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @PartiallyUpdatable
        struct MyStruct: Encodable, Decodable, PartiallyUpdatable {
            let int: Int
            var double: Double?
            var string: String
            var array: [Int?]
            var dictionary: [Int : String]?
        }
        """,
        expandedSource: """
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
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_publicAccessModifier() throws {

        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @PartiallyUpdatable
        public struct MyStruct {
            public let int: Int
            public var double: Double?
            public var string: String
            public var array: [Int?]
            var dictionary: [Int : String]?
        }
        """,
        expandedSource: """
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
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_explicitInternalAccessModifier() throws {

        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @PartiallyUpdatable
        internal struct MyStruct {
            internal let int: Int
            internal var double: Double?
            internal var string: String
            internal var array: [Int?]
            var dictionary: [Int : String]?
        }
        """,
        expandedSource: """
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
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_fileprivateAccessModifier() throws {

        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @PartiallyUpdatable
        fileprivate struct MyStruct {
            fileprivate let int: Int
            fileprivate var double: Double?
            fileprivate var string: String
            fileprivate var array: [Int?]
            var dictionary: [Int : String]?
        }
        """,
        expandedSource: """
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
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_privateAccessModifier() throws {

        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @PartiallyUpdatable
        private struct MyStruct {
            private let int: Int
            private var double: Double?
            private var string: String
            private var array: [Int?]
            var dictionary: [Int : String]?
        }
        """,
        expandedSource: """
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
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_ignoredProperty() throws {

        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
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
        """,
        expandedSource: """
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
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_ignoreCalculatedProperty() throws {

        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
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
        """,
        expandedSource: """
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
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_ignoreCalculatedGetSetProperty() throws {

        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
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
        """,
        expandedSource: """
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
        """,
        macros: MacroTesting.shared.testMacros
        )
    }

    func test_noTypeAnnotation() throws {

        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @PartiallyUpdatable
        struct MyStruct {
            let int = 1
            var double: Double?
            var string: String
            var array: [Int?]
            var dictionary: [Int : String]?
        }
        """,
        expandedSource: """
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
        """,
        diagnostics: [
            .init(
                id: .init(
                    domain: "PartiallyUpdatableMacro",
                    id: "noTypeAnnotation"
                ),
                message: "Property must include a type annotation to be included in \"@PartiallyUpdatable\" macro.",
                line: 3,
                column: 9,
                severity: .warning
            )
        ],
        macros: MacroTesting.shared.testMacros
        )
    }
}
