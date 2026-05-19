import SwiftSyntax
import SwiftSyntaxMacros

public struct PartiallyUpdatableOmittedMacro {}

// MARK: - Extension macro
extension PartiallyUpdatableOmittedMacro: AccessorMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        
        guard declaration.is(StructDeclSyntax.self) else {
            context.diagnose(
                .init(
                    node: node,
                    message: DiagnosticMessage.canOnlyBeAppliedToStructProperty
                )
            )
            return []
        }

        return []
    }
}
