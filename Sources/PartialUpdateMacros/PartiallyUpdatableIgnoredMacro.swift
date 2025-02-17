import SwiftSyntax
import SwiftSyntaxMacros

public struct PartiallyUpdatableIgnoredMacro {}

// MARK: - Extension macro
extension PartiallyUpdatableIgnoredMacro: AccessorMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        if declaration.is(EnumDeclSyntax.self) {
            context.diagnose(
                .init(
                    node: node,
                    message: DiagnosticMessage.cannotBeAppliedToEnum
                )
            )
        } else if declaration.is(StructDeclSyntax.self) {
            return []
        }

        return []
    }
}
