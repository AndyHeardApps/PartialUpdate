import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct PartialUpdateMacroPlugin: CompilerPlugin {

    let providingMacros: [any Macro.Type] = [
        PartiallyUpdatableMacro.self,
        PartiallyUpdatableIgnoredMacro.self,
        PartiallyUpdatableOmittedMacro.self
    ]
}
