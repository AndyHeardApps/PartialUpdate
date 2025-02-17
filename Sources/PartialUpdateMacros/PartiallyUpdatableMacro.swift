import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct PartiallyUpdatableMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {

        if let enumDeclaration = declaration.as(EnumDeclSyntax.self) {
            return try enumExtensionSyntax(
                declaration: enumDeclaration,
                type: type,
                in: context
            )
        } else if let structDeclaration = declaration.as(StructDeclSyntax.self) {
            return try structExtensionSyntax(
                declaration: structDeclaration,
                type: type,
                in: context
            )
        } else {
            throw DiagnosticsError(diagnostics: [
                .init(
                    node: Syntax(declaration),
                    message: DiagnosticMessage.notAValueType
                )
            ])
        }
    }
}

// MARK: - Inheritance clause
extension PartiallyUpdatableMacro {

    static func inheritanceClause(syntax: InheritanceClauseSyntax?, requireCodable: Bool) -> InheritanceClauseSyntax? {

        let inheritedTypeNames = syntax?.inheritedTypes
            .compactMap { type in
                type.type.trimmedDescription
                    .replacingOccurrences(of: "@retroactive", with: "")
                    .trimmingCharacters(in: .whitespaces)
            } ?? []

        if inheritedTypeNames.contains("PartiallyUpdatable") {
            return nil
        }

        var inheritedTypes: [InheritedTypeListSyntax.Element] = []
        if !inheritedTypeNames.contains("PartiallyUpdatable") {
            inheritedTypes.append(.init(type: IdentifierTypeSyntax(name: "PartiallyUpdatable")))
        }
        if inheritedTypeNames.contains("Encodable") && !inheritedTypeNames.contains("Decodable") && !inheritedTypeNames.contains("Codable") {
            inheritedTypes.append(.init(type: IdentifierTypeSyntax(name: "Decodable")))
        } else if !inheritedTypeNames.contains("Encodable") && inheritedTypeNames.contains("Decodable") && !inheritedTypeNames.contains("Codable") {
            inheritedTypes.append(.init(type: IdentifierTypeSyntax(name: "Encodable")))
        } else if !inheritedTypeNames.contains("Encodable") && !inheritedTypeNames.contains("Decodable") && !inheritedTypeNames.contains("Codable") {
            inheritedTypes.append(.init(type: IdentifierTypeSyntax(name: "Codable")))
        }

        guard !inheritedTypes.isEmpty else {
            return nil
        }

        if inheritedTypes.count > 1 {
            for index in 0..<inheritedTypes.count-1 {
                inheritedTypes[index].trailingComma = .commaToken()
            }
        }

        let inheritanceClause = InheritanceClauseSyntax(
            inheritedTypes: .init(inheritedTypes)
        )

        return inheritanceClause
    }
}

// MARK: - Guard statement
extension PartiallyUpdatableMacro {
    static func guardStatement(
        lhs: TokenSyntax,
        operator: String,
        rhs: TokenSyntax,
        returnExpression: some ExprSyntaxProtocol
    ) -> GuardStmtSyntax {
        GuardStmtSyntax(
            conditions: [
                .init(
                    condition: .expression(
                        .init(
                            InfixOperatorExprSyntax(
                                leftOperand: DeclReferenceExprSyntax(baseName: lhs),
                                operator: DeclReferenceExprSyntax(baseName: .binaryOperator(`operator`)),
                                rightOperand: DeclReferenceExprSyntax(baseName: rhs)
                            )
                        )
                    )
                )
            ],
            body: .init(
                statements: [
                    .init(
                        item: .stmt(
                            .init(ReturnStmtSyntax(
                                expression: returnExpression
                            ))
                        )
                    )
                ]
            )
        )
    }
}
