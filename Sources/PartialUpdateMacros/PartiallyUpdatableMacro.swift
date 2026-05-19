import Foundation
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
            try enumExtensionSyntax(
                declaration: enumDeclaration,
                type: type,
                in: context
            )
        } else if let structDeclaration = declaration.as(StructDeclSyntax.self) {
            try structExtensionSyntax(
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

    static func inheritanceClause(syntax: InheritanceClauseSyntax?) -> InheritanceClauseSyntax? {

        let inheritedTypeNames = syntax?.existingConformances ?? []

        var inheritedTypes: [InheritedTypeListSyntax.Element] = []
        if !inheritedTypeNames.contains("PartiallyUpdatable") {
            inheritedTypes.append(.init(type: IdentifierTypeSyntax(name: "PartiallyUpdatable")))
        }

        guard !inheritedTypes.isEmpty else {
            return nil
        }
        
        let inheritanceClause = InheritanceClauseSyntax(
            inheritedTypes: .init(inheritedTypes)
        )

        return inheritanceClause
    }

    static func addCodableConformances(
        to syntax: InheritanceClauseSyntax?,
        matching rootClause: InheritanceClauseSyntax?
    ) -> InheritanceClauseSyntax? {

        let protocols: Set<String> = ["Encodable", "Decodable", "Codable"]
        let existingConformances = syntax?.existingConformances ?? []
        let rootConformances = rootClause?.existingConformances.filter {
            protocols.contains($0)
        } ?? []

        var newInheritances: [String] = []
        for rootConformance in rootConformances {
            guard !existingConformances.contains(rootConformance) else {
                continue
            }
            newInheritances.append(rootConformance)
        }

        guard !newInheritances.isEmpty else {
            return syntax
        }

        let newInheritanceTypes = newInheritances.map {
            InheritedTypeListSyntax.Element(
                type: IdentifierTypeSyntax(
                    name: .identifier($0)
                )
            )
        }

        var newInheritanceClause = syntax ?? InheritanceClauseSyntax(inheritedTypes: [])
        newInheritanceClause.inheritedTypes.append(contentsOf: newInheritanceTypes)
        if newInheritanceClause.inheritedTypes.count > 1 {
            for index in newInheritanceClause.inheritedTypes.indices.prefix(newInheritances.count-1) {
                newInheritanceClause.inheritedTypes[index].trailingComma = .commaToken()
            }
        }

        return newInheritanceClause
    }
}

extension InheritanceClauseSyntax {
    fileprivate var existingConformances: [String] {
        inheritedTypes
            .compactMap { type in
                type.type.trimmedDescription
                    .replacing("@retroactive", with: "")
                    .trimmingCharacters(in: .whitespaces)
            }
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
