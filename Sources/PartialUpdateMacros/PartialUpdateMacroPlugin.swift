import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct PartialUpdateMacroPlugin: CompilerPlugin {

    let providingMacros: [Macro.Type] = [
        PartiallyUpdatableMacro.self,
    ]
}
