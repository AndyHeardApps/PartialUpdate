import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class PartialUpdateEnumTests: XCTestCase {

    func test_enumExpansion() throws {

        guard MacroTesting.shared.isEnabled else {
            throw XCTSkip()
        }

        assertMacroExpansion(
        """
        @PartiallyUpdatable
        enum MyEnum {
            case basic
            case int(Int)
            case person(first: String, second: String?)
        }
        """,
        expandedSource: """
        enum MyEnum {
            case basic
            case int(Int)
            case person(first: String, second: String?)
        }
        
        extension MyEnum: PartiallyUpdatable {

            enum PartialUpdate {
                case basic
                case int(Int.PartialUpdate?)
                case person(first: String.PartialUpdate?, second: String?.PartialUpdate?)
                case caseChange(MyEnum)
            }

            func update(from oldValue: MyEnum) -> PartialUpdate? {
                guard self != oldValue else {
                    return nil
                }
                switch (self, oldValue) {
                case (.basic, .basic):
                    return .basic
                case let (.int(current_int_$0), .int(old_int_$0)):
                    return .int(
                        current_int_$0.update(from: old_int_$0)
                    )
                case let (.person(current_person_first, current_person_second), .person(old_person_first, old_person_second)):
                    return .person(
                        first: current_person_first.update(from: old_person_first),
                        second: current_person_second.update(from: old_person_second)
                    )
                default:
                    return .caseChange(self)
                }
            }

            func updated(with partialUpdate: PartialUpdate?) throws -> MyEnum {
                guard let partialUpdate else {
                    return self
                }
                switch (self, partialUpdate) {
                case (.basic, .basic):
                    return .basic
                case let (.int(current_int_$0), .int(update_int_$0)):
                    return try .int(
                        current_int_$0.updated(with: update_int_$0)
                    )
                case let (.person(current_person_first, current_person_second), .person(update_person_first, update_person_second)):
                    return try .person(
                        first: current_person_first.updated(with: update_person_first),
                        second: current_person_second.updated(with: update_person_second)
                    )
                case let (_, .caseChange(update)):
                    return update
                default:
                    throw PartialUpdateError.updatingEnumWithIncorrectCase
                }
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
        enum MyEnum: Codable {
            case basic
            case int(Int)
            case person(first: String, second: String?)
        }
        """,
        expandedSource: """
        enum MyEnum: Codable {
            case basic
            case int(Int)
            case person(first: String, second: String?)
        }
        
        extension MyEnum: PartiallyUpdatable {

            enum PartialUpdate: Codable {
                case basic
                case int(Int.PartialUpdate?)
                case person(first: String.PartialUpdate?, second: String?.PartialUpdate?)
                case caseChange(MyEnum)
            }

            func update(from oldValue: MyEnum) -> PartialUpdate? {
                guard self != oldValue else {
                    return nil
                }
                switch (self, oldValue) {
                case (.basic, .basic):
                    return .basic
                case let (.int(current_int_$0), .int(old_int_$0)):
                    return .int(
                        current_int_$0.update(from: old_int_$0)
                    )
                case let (.person(current_person_first, current_person_second), .person(old_person_first, old_person_second)):
                    return .person(
                        first: current_person_first.update(from: old_person_first),
                        second: current_person_second.update(from: old_person_second)
                    )
                default:
                    return .caseChange(self)
                }
            }

            func updated(with partialUpdate: PartialUpdate?) throws -> MyEnum {
                guard let partialUpdate else {
                    return self
                }
                switch (self, partialUpdate) {
                case (.basic, .basic):
                    return .basic
                case let (.int(current_int_$0), .int(update_int_$0)):
                    return try .int(
                        current_int_$0.updated(with: update_int_$0)
                    )
                case let (.person(current_person_first, current_person_second), .person(update_person_first, update_person_second)):
                    return try .person(
                        first: current_person_first.updated(with: update_person_first),
                        second: current_person_second.updated(with: update_person_second)
                    )
                case let (_, .caseChange(update)):
                    return update
                default:
                    throw PartialUpdateError.updatingEnumWithIncorrectCase
                }
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
        enum MyEnum: Encodable, Decodable {
            case basic
            case int(Int)
            case person(first: String, second: String?)
        }
        """,
        expandedSource: """
        enum MyEnum: Encodable, Decodable {
            case basic
            case int(Int)
            case person(first: String, second: String?)
        }
        
        extension MyEnum: PartiallyUpdatable {

            enum PartialUpdate: Encodable, Decodable {
                case basic
                case int(Int.PartialUpdate?)
                case person(first: String.PartialUpdate?, second: String?.PartialUpdate?)
                case caseChange(MyEnum)
            }

            func update(from oldValue: MyEnum) -> PartialUpdate? {
                guard self != oldValue else {
                    return nil
                }
                switch (self, oldValue) {
                case (.basic, .basic):
                    return .basic
                case let (.int(current_int_$0), .int(old_int_$0)):
                    return .int(
                        current_int_$0.update(from: old_int_$0)
                    )
                case let (.person(current_person_first, current_person_second), .person(old_person_first, old_person_second)):
                    return .person(
                        first: current_person_first.update(from: old_person_first),
                        second: current_person_second.update(from: old_person_second)
                    )
                default:
                    return .caseChange(self)
                }
            }

            func updated(with partialUpdate: PartialUpdate?) throws -> MyEnum {
                guard let partialUpdate else {
                    return self
                }
                switch (self, partialUpdate) {
                case (.basic, .basic):
                    return .basic
                case let (.int(current_int_$0), .int(update_int_$0)):
                    return try .int(
                        current_int_$0.updated(with: update_int_$0)
                    )
                case let (.person(current_person_first, current_person_second), .person(update_person_first, update_person_second)):
                    return try .person(
                        first: current_person_first.updated(with: update_person_first),
                        second: current_person_second.updated(with: update_person_second)
                    )
                case let (_, .caseChange(update)):
                    return update
                default:
                    throw PartialUpdateError.updatingEnumWithIncorrectCase
                }
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
        enum MyEnum: Encodable, Decodable, PartiallyUpdatable {
            case basic
            case int(Int)
            case person(first: String, second: String?)
        }
        """,
        expandedSource: """
        enum MyEnum: Encodable, Decodable, PartiallyUpdatable {
            case basic
            case int(Int)
            case person(first: String, second: String?)
        }
        
        extension MyEnum {

            enum PartialUpdate: Encodable, Decodable {
                case basic
                case int(Int.PartialUpdate?)
                case person(first: String.PartialUpdate?, second: String?.PartialUpdate?)
                case caseChange(MyEnum)
            }

            func update(from oldValue: MyEnum) -> PartialUpdate? {
                guard self != oldValue else {
                    return nil
                }
                switch (self, oldValue) {
                case (.basic, .basic):
                    return .basic
                case let (.int(current_int_$0), .int(old_int_$0)):
                    return .int(
                        current_int_$0.update(from: old_int_$0)
                    )
                case let (.person(current_person_first, current_person_second), .person(old_person_first, old_person_second)):
                    return .person(
                        first: current_person_first.update(from: old_person_first),
                        second: current_person_second.update(from: old_person_second)
                    )
                default:
                    return .caseChange(self)
                }
            }

            func updated(with partialUpdate: PartialUpdate?) throws -> MyEnum {
                guard let partialUpdate else {
                    return self
                }
                switch (self, partialUpdate) {
                case (.basic, .basic):
                    return .basic
                case let (.int(current_int_$0), .int(update_int_$0)):
                    return try .int(
                        current_int_$0.updated(with: update_int_$0)
                    )
                case let (.person(current_person_first, current_person_second), .person(update_person_first, update_person_second)):
                    return try .person(
                        first: current_person_first.updated(with: update_person_first),
                        second: current_person_second.updated(with: update_person_second)
                    )
                case let (_, .caseChange(update)):
                    return update
                default:
                    throw PartialUpdateError.updatingEnumWithIncorrectCase
                }
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
        public enum MyEnum {
            case basic
            case int(Int)
            case person(first: String, second: String?)
        }
        """,
        expandedSource: """
        public enum MyEnum {
            case basic
            case int(Int)
            case person(first: String, second: String?)
        }
        
        extension MyEnum: PartiallyUpdatable {
        
            public enum PartialUpdate {
                case basic
                case int(Int.PartialUpdate?)
                case person(first: String.PartialUpdate?, second: String?.PartialUpdate?)
                case caseChange(MyEnum)
            }
        
            public func update(from oldValue: MyEnum) -> PartialUpdate? {
                guard self != oldValue else {
                    return nil
                }
                switch (self, oldValue) {
                case (.basic, .basic):
                    return .basic
                case let (.int(current_int_$0), .int(old_int_$0)):
                    return .int(
                        current_int_$0.update(from: old_int_$0)
                    )
                case let (.person(current_person_first, current_person_second), .person(old_person_first, old_person_second)):
                    return .person(
                        first: current_person_first.update(from: old_person_first),
                        second: current_person_second.update(from: old_person_second)
                    )
                default:
                    return .caseChange(self)
                }
            }
        
            public func updated(with partialUpdate: PartialUpdate?) throws -> MyEnum {
                guard let partialUpdate else {
                    return self
                }
                switch (self, partialUpdate) {
                case (.basic, .basic):
                    return .basic
                case let (.int(current_int_$0), .int(update_int_$0)):
                    return try .int(
                        current_int_$0.updated(with: update_int_$0)
                    )
                case let (.person(current_person_first, current_person_second), .person(update_person_first, update_person_second)):
                    return try .person(
                        first: current_person_first.updated(with: update_person_first),
                        second: current_person_second.updated(with: update_person_second)
                    )
                case let (_, .caseChange(update)):
                    return update
                default:
                    throw PartialUpdateError.updatingEnumWithIncorrectCase
                }
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
        internal enum MyEnum {
            case basic
            case int(Int)
            case person(first: String, second: String?)
        }
        """,
        expandedSource: """
        internal enum MyEnum {
            case basic
            case int(Int)
            case person(first: String, second: String?)
        }
        
        extension MyEnum: PartiallyUpdatable {
        
            enum PartialUpdate {
                case basic
                case int(Int.PartialUpdate?)
                case person(first: String.PartialUpdate?, second: String?.PartialUpdate?)
                case caseChange(MyEnum)
            }
        
            func update(from oldValue: MyEnum) -> PartialUpdate? {
                guard self != oldValue else {
                    return nil
                }
                switch (self, oldValue) {
                case (.basic, .basic):
                    return .basic
                case let (.int(current_int_$0), .int(old_int_$0)):
                    return .int(
                        current_int_$0.update(from: old_int_$0)
                    )
                case let (.person(current_person_first, current_person_second), .person(old_person_first, old_person_second)):
                    return .person(
                        first: current_person_first.update(from: old_person_first),
                        second: current_person_second.update(from: old_person_second)
                    )
                default:
                    return .caseChange(self)
                }
            }
        
            func updated(with partialUpdate: PartialUpdate?) throws -> MyEnum {
                guard let partialUpdate else {
                    return self
                }
                switch (self, partialUpdate) {
                case (.basic, .basic):
                    return .basic
                case let (.int(current_int_$0), .int(update_int_$0)):
                    return try .int(
                        current_int_$0.updated(with: update_int_$0)
                    )
                case let (.person(current_person_first, current_person_second), .person(update_person_first, update_person_second)):
                    return try .person(
                        first: current_person_first.updated(with: update_person_first),
                        second: current_person_second.updated(with: update_person_second)
                    )
                case let (_, .caseChange(update)):
                    return update
                default:
                    throw PartialUpdateError.updatingEnumWithIncorrectCase
                }
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
        fileprivate enum MyEnum {
            case basic
            case int(Int)
            case person(first: String, second: String?)
        }
        """,
        expandedSource: """
        fileprivate enum MyEnum {
            case basic
            case int(Int)
            case person(first: String, second: String?)
        }
        
        extension MyEnum: PartiallyUpdatable {
        
            fileprivate enum PartialUpdate {
                case basic
                case int(Int.PartialUpdate?)
                case person(first: String.PartialUpdate?, second: String?.PartialUpdate?)
                case caseChange(MyEnum)
            }
        
            fileprivate func update(from oldValue: MyEnum) -> PartialUpdate? {
                guard self != oldValue else {
                    return nil
                }
                switch (self, oldValue) {
                case (.basic, .basic):
                    return .basic
                case let (.int(current_int_$0), .int(old_int_$0)):
                    return .int(
                        current_int_$0.update(from: old_int_$0)
                    )
                case let (.person(current_person_first, current_person_second), .person(old_person_first, old_person_second)):
                    return .person(
                        first: current_person_first.update(from: old_person_first),
                        second: current_person_second.update(from: old_person_second)
                    )
                default:
                    return .caseChange(self)
                }
            }
        
            fileprivate func updated(with partialUpdate: PartialUpdate?) throws -> MyEnum {
                guard let partialUpdate else {
                    return self
                }
                switch (self, partialUpdate) {
                case (.basic, .basic):
                    return .basic
                case let (.int(current_int_$0), .int(update_int_$0)):
                    return try .int(
                        current_int_$0.updated(with: update_int_$0)
                    )
                case let (.person(current_person_first, current_person_second), .person(update_person_first, update_person_second)):
                    return try .person(
                        first: current_person_first.updated(with: update_person_first),
                        second: current_person_second.updated(with: update_person_second)
                    )
                case let (_, .caseChange(update)):
                    return update
                default:
                    throw PartialUpdateError.updatingEnumWithIncorrectCase
                }
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
        private enum MyEnum {
            case basic
            case int(Int)
            case person(first: String, second: String?)
        }
        """,
        expandedSource: """
        private enum MyEnum {
            case basic
            case int(Int)
            case person(first: String, second: String?)
        }
        
        extension MyEnum: PartiallyUpdatable {
        
            fileprivate enum PartialUpdate {
                case basic
                case int(Int.PartialUpdate?)
                case person(first: String.PartialUpdate?, second: String?.PartialUpdate?)
                case caseChange(MyEnum)
            }
        
            fileprivate func update(from oldValue: MyEnum) -> PartialUpdate? {
                guard self != oldValue else {
                    return nil
                }
                switch (self, oldValue) {
                case (.basic, .basic):
                    return .basic
                case let (.int(current_int_$0), .int(old_int_$0)):
                    return .int(
                        current_int_$0.update(from: old_int_$0)
                    )
                case let (.person(current_person_first, current_person_second), .person(old_person_first, old_person_second)):
                    return .person(
                        first: current_person_first.update(from: old_person_first),
                        second: current_person_second.update(from: old_person_second)
                    )
                default:
                    return .caseChange(self)
                }
            }
        
            fileprivate func updated(with partialUpdate: PartialUpdate?) throws -> MyEnum {
                guard let partialUpdate else {
                    return self
                }
                switch (self, partialUpdate) {
                case (.basic, .basic):
                    return .basic
                case let (.int(current_int_$0), .int(update_int_$0)):
                    return try .int(
                        current_int_$0.updated(with: update_int_$0)
                    )
                case let (.person(current_person_first, current_person_second), .person(update_person_first, update_person_second)):
                    return try .person(
                        first: current_person_first.updated(with: update_person_first),
                        second: current_person_second.updated(with: update_person_second)
                    )
                case let (_, .caseChange(update)):
                    return update
                default:
                    throw PartialUpdateError.updatingEnumWithIncorrectCase
                }
            }
        }
        """,
        macros: MacroTesting.shared.testMacros
        )
    }
}
