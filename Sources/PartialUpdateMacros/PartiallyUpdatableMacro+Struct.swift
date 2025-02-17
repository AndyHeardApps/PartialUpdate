import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

extension PartiallyUpdatableMacro {

    static func structExtensionSyntax(
        declaration: StructDeclSyntax,
        type: some TypeSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {

        let accessScopeModifier = declaration.modifiers.first(where: \.isNeededAccessLevelModifier)?.minimumProtocolWitnessVisibilityForAccessModifier

        let properties = declaration.memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }
            .flatMap { variable in
                variable.bindings.compactMap { binding in
                    Property(
                        declaration: variable,
                        binding: binding,
                        in: context
                    )
                }
            }

        let partialUpdateDeclaration = partialUpdateDeclaration(
            properties: properties,
            accessScopeModifier: accessScopeModifier
        )

        let updateFromFunctionDeclaration = updateFromFunctionDeclaration(
            properties: properties,
            type: declaration.name,
            accessScopeModifier: accessScopeModifier
        )

        let updatedWithFunctionDeclaration = updatedWithFunctionDeclaration(
            properties: properties,
            type: declaration.name,
            accessScopeModifier: accessScopeModifier
        )

        let extensionDeclaration = ExtensionDeclSyntax(
            extendedType: type,
            inheritanceClause: inheritanceClause(syntax: declaration.inheritanceClause, requireCodable: false),
            memberBlock: .init(
                members: .init(
                    itemsBuilder: {
                        partialUpdateDeclaration
                        updateFromFunctionDeclaration
                        updatedWithFunctionDeclaration
                    }
                )
            )
        )

        return [extensionDeclaration]
    }
}

// MARK: - Update from function declaration
extension PartiallyUpdatableMacro {
    private static func updateFromFunctionDeclaration(
        properties: [Property],
        type: TokenSyntax,
        accessScopeModifier: TokenSyntax?
    ) -> FunctionDeclSyntax {
        FunctionDeclSyntax(
            leadingTrivia: .newlines(2),
            modifiers: .init {
                if let accessScopeModifier {
                    DeclModifierSyntax(name: accessScopeModifier)
                }
            },
            name: .identifier("update"),
            signature: .init(
                parameterClause: .init(
                    parameters: [
                        .init(
                            firstName: .identifier("from"),
                            secondName: .identifier("oldValue"),
                            type: IdentifierTypeSyntax(name: type)
                        )
                        .trimmed
                    ]
                ),
                returnClause: .init(
                    type: OptionalTypeSyntax(
                        wrappedType: IdentifierTypeSyntax(
                            name: .identifier("PartialUpdate")
                        )
                    )
                )
            ),
            body: .init(
                statements: [
                    .init(
                        item: .stmt(
                            .init(
                                guardStatement(
                                    lhs: .keyword(.self),
                                    operator: "!=",
                                    rhs: .identifier("oldValue"),
                                    returnExpression: NilLiteralExprSyntax()
                                )
                            )
                        )
                    ),
                    .init(
                        item: .stmt(
                            .init(
                                ReturnStmtSyntax(
                                    expression: initializer(
                                        properties: properties.filter { !$0.isIgnored },
                                        typeName: "PartialUpdate",
                                        functionName: { _ in "update" },
                                        parameterName: { _ in "from" },
                                        parameterValue: { property in
                                            MemberAccessExprSyntax(
                                                base: DeclReferenceExprSyntax(baseName: "oldValue"),
                                                name: property.identifier.identifier
                                            )
                                        }
                                    )
                                )
                            )
                        )
                    )
                ]
            )
        )
    }
}

// MARK: - Updated with function declaration
extension PartiallyUpdatableMacro {
    private static func updatedWithFunctionDeclaration(
        properties: [Property],
        type: TokenSyntax,
        accessScopeModifier: TokenSyntax?
    ) -> FunctionDeclSyntax {
        FunctionDeclSyntax(
            leadingTrivia: .newlines(2),
            modifiers: .init {
                if let accessScopeModifier {
                    DeclModifierSyntax(name: accessScopeModifier)
                }
            },
            name: .identifier("updated"),
            signature: .init(
                parameterClause: .init(
                    parameters: [
                        .init(
                            firstName: .identifier("with"),
                            secondName: .identifier("partialUpdate"),
                            type: OptionalTypeSyntax(
                                wrappedType: IdentifierTypeSyntax(
                                    name: .identifier("PartialUpdate")
                                )
                            )
                        )
                        .trimmed
                    ]
                ),
                effectSpecifiers: .init(
                    throwsClause: .init(throwsSpecifier: .keyword(.throws))
                ),
                returnClause: .init(
                    type: IdentifierTypeSyntax(name: type)
                )
            ),
            body: .init(
                statements: [
                    .init(
                        item: .stmt(
                            .init(
                                ReturnStmtSyntax(
                                    expression: TryExprSyntax(
                                        expression: initializer(
                                            properties: properties,
                                            typeName: type.text,
                                            functionName: { $0.isIgnored ? nil : "updated" },
                                            parameterName: { $0.isIgnored ? nil : "with" },
                                            parameterValue: { property in
                                                MemberAccessExprSyntax(
                                                    base: OptionalChainingExprSyntax(
                                                        expression: DeclReferenceExprSyntax(
                                                            baseName: .identifier("partialUpdate")
                                                        )
                                                    ),
                                                    name: property.identifier.identifier
                                                )
                                            }
                                        )
                                    )
                                )
                            )
                        )
                    )
                ]
            )
        )
    }
}

// MARK: - Partial update declaration
extension PartiallyUpdatableMacro {
    private static func partialUpdateDeclaration(
        properties: [Property],
        accessScopeModifier: TokenSyntax?
    ) -> StructDeclSyntax {

        StructDeclSyntax(
            leadingTrivia: .newlines(2),
            modifiers: .init {
                if let accessScopeModifier {
                    DeclModifierSyntax(name: accessScopeModifier)
                }
            },
            name: "PartialUpdate",
            inheritanceClause: .init(
                inheritedTypes: [
                    .init(
                        type: IdentifierTypeSyntax(name: "Codable")
                    )
                ]
            ),
            memberBlock: .init(
                members: .init(
                    itemsBuilder: {
                        for property in properties where !property.isIgnored {
                            VariableDeclSyntax(
                                modifiers: .init {
                                    if let accessScopeModifier {
                                        DeclModifierSyntax(name: accessScopeModifier)
                                    }
                                },
                                .let,
                                name: .init(property.identifier),
                                type: .init(
                                    type: OptionalTypeSyntax(
                                        wrappedType: MemberTypeSyntax(
                                            baseType: property.type,
                                            name: .identifier("PartialUpdate")
                                        )
                                    )
                                )
                            )
                        }
                    }
                )
            )
        )
    }
}

// MARK: - Initializer helper
extension PartiallyUpdatableMacro {
    private static func initializer(
        properties: [Property],
        typeName: String,
        functionName: (Property) -> String?,
        parameterName: (Property) -> String?,
        parameterValue: (Property) -> some ExprSyntaxProtocol
    ) -> FunctionCallExprSyntax {
        FunctionCallExprSyntax(
            calledExpression: DeclReferenceExprSyntax(baseName: .identifier(typeName)),
            leftParen: .leftParenToken(),
            arguments: .init {
                for property in properties {
                    if let functionName = functionName(property) {
                        .init(
                            leadingTrivia: .newline,
                            label: property.identifier.identifier,
                            colon: .colonToken(),
                            expression:
                                FunctionCallExprSyntax(
                                calledExpression: MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(baseName: property.identifier.identifier),
                                    name: .identifier(functionName)
                                ),
                                leftParen: .leftParenToken(),
                                arguments: [
                                    LabeledExprSyntax(
                                        label: parameterName(property).map { .identifier($0) },
                                        colon: .colonToken(),
                                        expression: parameterValue(property)
                                    )
                                ],
                                rightParen: .rightParenToken()
                            )
                        )
                    } else {
                        .init(
                            leadingTrivia: .newline,
                            label: property.identifier.identifier,
                            colon: .colonToken(),
                            expression: DeclReferenceExprSyntax(baseName: property.identifier.identifier)
                        )
                    }
                }
            },
            rightParen: .rightParenToken(leadingTrivia: .newline)
        )
    }

}

// MARK: - Property
extension PartiallyUpdatableMacro {
    private struct Property {

        // Properties
        let identifier: IdentifierPatternSyntax
        let type: TypeSyntax
        let isIgnored: Bool

        // Initializer
        init?(
            declaration: VariableDeclSyntax,
            binding: PatternBindingSyntax,
            in context: some MacroExpansionContext
        ) {

            let attributeNames = declaration.attributes
                .compactMap { $0.as(AttributeSyntax.self)?.attributeName }
                .compactMap { $0.as(IdentifierTypeSyntax.self)?.name.text }

            guard let identifier = binding.pattern.as(IdentifierPatternSyntax.self) else {
                return nil
            }

            if
                let accessors = binding.accessorBlock?.accessors
                    .as(AccessorDeclListSyntax.self)?
                    .compactMap(\.accessorSpecifier.tokenKind),
                accessors.contains(.keyword(.set)) || accessors.contains(.keyword(.get))
            {
                return nil
            } else if
                let accessors = binding.accessorBlock?.accessors,
                accessors.is(CodeBlockItemListSyntax.self)
            {
                return nil
            }

            guard let type = binding.typeAnnotation?.type else {
                context.diagnose(
                    .init(
                        node: binding,
                        message: DiagnosticMessage.noTypeAnnotation
                    )
                )
                return nil
            }

            self.identifier = identifier
            self.type = type
            self.isIgnored = attributeNames.contains("PartiallyUpdatableIgnored")
        }
    }
}
