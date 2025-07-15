import SwiftSyntaxMacros
#if canImport(PartialUpdateMacros)
@testable import PartialUpdateMacros
#endif

struct MacroTesting {

    // MARK: - Static properties
    static let shared = MacroTesting()

    // MARK: - Properties
    let testMacros: [String : any Macro.Type]
    let isEnabled: Bool

    // MARK: - Initializer
    private init() {

        #if canImport(PartialUpdateMacros)
        self.testMacros = [
            "PartiallyUpdatable" : PartiallyUpdatableMacro.self
        ]
        self.isEnabled = true
        #else
        self.testMacros = [:]
        self.isEnabled = false
        #endif
    }
}
