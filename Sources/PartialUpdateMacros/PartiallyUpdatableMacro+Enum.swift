import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

extension PartiallyUpdatableMacro {

    static func enumExtensionSyntax(
        declaration: EnumDeclSyntax,
        type: some TypeSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {

        let accessScopeModifier = declaration.modifiers.first(where: \.isNeededAccessLevelModifier)?.minimumProtocolWitnessVisibilityForAccessModifier

        let enumCases = parseEnumCases(on: declaration)

        let partialUpdateDeclaration = partialUpdateDeclaration(
            enumCases: enumCases,
            type: type,
            accessScopeModifier: accessScopeModifier,
            in: declaration
        )

        let updatedWithFunctionDeclaration = updatedWithFunctionDeclaration(
            enumCases: enumCases,
            type: type,
            accessScopeModifier: accessScopeModifier
        )

        let updateFromFunctionDeclaration = updateFromFunctionDeclaration(
            enumCases: enumCases,
            type: type,
            accessScopeModifier: accessScopeModifier
        )

        let extensionDeclaration = ExtensionDeclSyntax(
            extendedType: type,
            inheritanceClause: inheritanceClause(syntax: declaration.inheritanceClause),
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

// MARK: - Partial update declaration
extension PartiallyUpdatableMacro {
    private static func partialUpdateDeclaration(
        enumCases: [EnumCase],
        type: some TypeSyntaxProtocol,
        accessScopeModifier: TokenSyntax?,
        in declaration: EnumDeclSyntax
    ) -> EnumDeclSyntax {

        EnumDeclSyntax(
            leadingTrivia: .newlines(2),
            modifiers: .init {
                if let accessScopeModifier {
                    DeclModifierSyntax(name: accessScopeModifier)
                }
            },
            name: "PartialUpdate",
            inheritanceClause: addCodableConformances(to: nil, matching: declaration.inheritanceClause),
            memberBlock: .init(
                members: .init(
                    itemsBuilder: {
                        for enumCase in enumCases {
                            EnumCaseDeclSyntax(
                                elementsBuilder: {
                                    EnumCaseElementSyntax(
                                        name: enumCase.name,
                                        parameterClause: enumCase.associatedValues.isEmpty ? nil :  EnumCaseParameterClauseSyntax(
                                            parameters: .init {
                                                for parameter in enumCase.associatedValues {
                                                    EnumCaseParameterSyntax(
                                                        firstName: parameter.name,
                                                        colon: parameter.name == nil ? nil : .colonToken(),
                                                        type: OptionalTypeSyntax(
                                                            wrappedType: MemberTypeSyntax(
                                                                baseType: parameter.type,
                                                                name: .identifier("PartialUpdate")
                                                            )
                                                        )
                                                    )
                                                }
                                            }
                                        )
                                    )
                                }
                            )
                        }
                        EnumCaseDeclSyntax(
                            elements: [
                                .init(
                                    name: "caseChange",
                                    parameterClause: .init(
                                        parameters: [
                                            EnumCaseParameterSyntax(
                                                type: type
                                            )
                                        ]
                                    )
                                )
                            ]
                        )
                    }
                )
            )
        )
    }
}

// MARK: - Updated from function declaration
extension PartiallyUpdatableMacro {
    private static func updateFromFunctionDeclaration(
        enumCases: [EnumCase],
        type: some TypeSyntaxProtocol,
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
                            type: type
                        )
                        .trimmed
                    ]
                ),
                returnClause: .init(
                    type: OptionalTypeSyntax(
                        wrappedType: IdentifierTypeSyntax(name: .identifier("PartialUpdate"))
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
                        item: .expr(
                            .init(
                                SwitchExprSyntax(
                                    subject: TupleExprSyntax(elements: [
                                        .init(expression: DeclReferenceExprSyntax(baseName: .keyword(.self)), trailingComma: .commaToken()),
                                        .init(expression: DeclReferenceExprSyntax(baseName: .identifier("oldValue")))
                                    ]),
                                    cases: .init {
                                        for enumCase in enumCases {

                                            let patternMatch = patternMatch(
                                                enumCase: enumCase,
                                                lhsPrefix: "current",
                                                rhsPrefix: "old"
                                            )

                                            let updateCall = caseInitializer(
                                                enumCase: enumCase,
                                                baseName: { $0.uniqueName(prefixedWith: "current") },
                                                functionName: { _ in .identifier("update") },
                                                parameterName: { _ in .identifier("from") },
                                                parameterValue: { $0.uniqueName(prefixedWith: "old") }
                                            )

                                            SwitchCaseSyntax(
                                                label: .case(
                                                    SwitchCaseLabelSyntax(
                                                        caseItems: SwitchCaseItemListSyntax {
                                                            if enumCase.associatedValues.isEmpty {
                                                                SwitchCaseItemSyntax(pattern: patternMatch)
                                                            } else {
                                                                SwitchCaseItemSyntax(
                                                                    pattern: ValueBindingPatternSyntax(
                                                                        bindingSpecifier: .keyword(.let),
                                                                        pattern: patternMatch
                                                                    )
                                                                )
                                                            }
                                                        }
                                                    )
                                                ),
                                                statements: .init {
                                                    .init(
                                                        item: .init(
                                                            ReturnStmtSyntax(
                                                                expression: updateCall
                                                            )
                                                        )
                                                    )
                                                }
                                            )
                                        }
                                        SwitchCaseSyntax(
                                            label: .default(.init()),
                                            statements: [
                                                .init(
                                                    item: .init(
                                                        ReturnStmtSyntax(
                                                            expression: FunctionCallExprSyntax(
                                                                calledExpression: MemberAccessExprSyntax(
                                                                    name: .identifier("caseChange")
                                                                ),
                                                                leftParen: .leftParenToken(),
                                                                arguments: [
                                                                    .init(
                                                                        expression: DeclReferenceExprSyntax(
                                                                            baseName: .keyword(.self)
                                                                        )
                                                                    )
                                                                ],
                                                                rightParen: .rightParenToken()
                                                            )
                                                        )
                                                    )
                                                )
                                            ]
                                        )
                                    }
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
        enumCases: [EnumCase],
        type: some TypeSyntaxProtocol,
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
                    type: type
                )
            ),
            body: .init(
                statements: [
                    .init(
                        item: .stmt(
                            .init(
                                GuardStmtSyntax(
                                    conditions: [
                                        .init(
                                            condition: .optionalBinding(
                                                .init(
                                                    bindingSpecifier: .keyword(.let),
                                                    pattern: IdentifierPatternSyntax(identifier: .identifier("partialUpdate"))
                                                )
                                            )
                                        )
                                    ],
                                    body: .init(
                                        statements: [
                                            .init(
                                                item: .stmt(
                                                    .init(ReturnStmtSyntax(
                                                        expression: DeclReferenceExprSyntax(baseName: .keyword(.self))
                                                    ))
                                                )
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                    ),
                    .init(
                        item: .expr(
                            .init(
                                SwitchExprSyntax(
                                    subject: TupleExprSyntax(elements: [
                                        .init(expression: DeclReferenceExprSyntax(baseName: .keyword(.self)), trailingComma: .commaToken()),
                                        .init(expression: DeclReferenceExprSyntax(baseName: .identifier("partialUpdate")))
                                    ]),
                                    cases: .init {
                                        for enumCase in enumCases {

                                            let patternMatch = patternMatch(
                                                enumCase: enumCase,
                                                lhsPrefix: "current",
                                                rhsPrefix: "update"
                                            )

                                            let updateCall = caseInitializer(
                                                enumCase: enumCase,
                                                baseName: { $0.uniqueName(prefixedWith: "current") },
                                                functionName: { _ in .identifier("updated") },
                                                parameterName: { _ in .identifier("with") },
                                                parameterValue: { $0.uniqueName(prefixedWith: "update") }
                                            )

                                            SwitchCaseSyntax(
                                                label: .case(
                                                    SwitchCaseLabelSyntax(
                                                        caseItems: SwitchCaseItemListSyntax {
                                                            if enumCase.associatedValues.isEmpty {
                                                                SwitchCaseItemSyntax(pattern: patternMatch)
                                                            } else {
                                                                SwitchCaseItemSyntax(
                                                                    pattern: ValueBindingPatternSyntax(
                                                                        bindingSpecifier: .keyword(.let),
                                                                        pattern: patternMatch
                                                                    )
                                                                )
                                                            }
                                                        }
                                                    )
                                                ),
                                                statements: .init {
                                                    if enumCase.associatedValues.isEmpty {
                                                        .init(
                                                            item: .init(
                                                                ReturnStmtSyntax(
                                                                    expression: updateCall
                                                                )
                                                            )
                                                        )
                                                    } else {
                                                        .init(
                                                            item: .init(
                                                                ReturnStmtSyntax(
                                                                    expression: TryExprSyntax(
                                                                        expression: updateCall
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    }
                                                }
                                            )
                                        }
                                        SwitchCaseSyntax(
                                            label: .case(
                                                .init(
                                                    caseItems: [
                                                        SwitchCaseItemSyntax(
                                                            pattern: ValueBindingPatternSyntax(
                                                                bindingSpecifier: .keyword(.let),
                                                                pattern: ExpressionPatternSyntax(
                                                                    expression: TupleExprSyntax(
                                                                        elements: [
                                                                            LabeledExprSyntax(
                                                                                expression: DiscardAssignmentExprSyntax(),
                                                                                trailingComma: .commaToken()
                                                                            ),
                                                                            LabeledExprSyntax(
                                                                                expression: FunctionCallExprSyntax(
                                                                                    calledExpression: MemberAccessExprSyntax(
                                                                                        name: .identifier("caseChange")
                                                                                    ),
                                                                                    leftParen: .leftParenToken(),
                                                                                    arguments: [
                                                                                        LabeledExprSyntax(
                                                                                            expression: PatternExprSyntax(
                                                                                                pattern: IdentifierPatternSyntax(identifier: .identifier("update"))
                                                                                            )
                                                                                        )
                                                                                    ],
                                                                                    rightParen: .rightParenToken()
                                                                                )
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    ]
                                                )
                                            ),
                                            statements: [
                                                .init(
                                                    item: .init(
                                                        ReturnStmtSyntax(
                                                            expression: DeclReferenceExprSyntax(
                                                                baseName: .identifier(
                                                                    "update"
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            ]
                                        )
                                        SwitchCaseSyntax(
                                            label: .default(.init()),
                                            statements: [
                                                .init(
                                                    item: .init(
                                                        ThrowStmtSyntax(
                                                            expression: MemberAccessExprSyntax(
                                                                base: DeclReferenceExprSyntax(baseName: .identifier("PartialUpdateError")),
                                                                period: .periodToken(),
                                                                name: .identifier("updatingEnumWithIncorrectCase")
                                                            )
                                                        )
                                                    )
                                                )
                                            ]
                                        )
                                    }
                                )
                            )
                        )
                    )
                ]
            )
        )
    }
}

// MARK: - Pattern match helper
extension PartiallyUpdatableMacro {

    private static func patternMatch(
        enumCase: EnumCase,
        lhsPrefix: String,
        rhsPrefix: String
    ) -> ExpressionPatternSyntax {
        ExpressionPatternSyntax(
            expression: TupleExprSyntax(
                elements: .init {
                    LabeledExprSyntax(
                        expression: FunctionCallExprSyntax(
                            calledExpression: MemberAccessExprSyntax(name: enumCase.name),
                            leftParen: enumCase.associatedValues.isEmpty ? nil : .leftParenToken(),
                            arguments: .init {
                                for associatedValue in enumCase.associatedValues {
                                    LabeledExprSyntax(
                                        expression: PatternExprSyntax(
                                            pattern: IdentifierPatternSyntax(
                                                identifier: associatedValue.uniqueName(prefixedWith: lhsPrefix)
                                            )
                                        )
                                    )
                                }
                            },
                            rightParen: enumCase.associatedValues.isEmpty ? nil : .rightParenToken()
                        )
                    )
                    LabeledExprSyntax(
                        expression: FunctionCallExprSyntax(
                            calledExpression: MemberAccessExprSyntax(name: enumCase.name),
                            leftParen: enumCase.associatedValues.isEmpty ? nil : .leftParenToken(),
                            arguments: .init {
                                for associatedValue in enumCase.associatedValues {
                                    LabeledExprSyntax(
                                        expression: PatternExprSyntax(
                                            pattern: IdentifierPatternSyntax(
                                                identifier: associatedValue.uniqueName(prefixedWith: rhsPrefix)
                                            )
                                        )
                                    )
                                }
                            },
                            rightParen: enumCase.associatedValues.isEmpty ? nil : .rightParenToken()
                        )
                    )
                }
            )
        )
    }
}

// MARK: - Case initializer
extension PartiallyUpdatableMacro {

    private static func caseInitializer(
        enumCase: EnumCase,
        baseName: (EnumCase.AssociatedValue) -> TokenSyntax,
        functionName: (EnumCase.AssociatedValue) -> TokenSyntax,
        parameterName: (EnumCase.AssociatedValue) -> TokenSyntax,
        parameterValue: (EnumCase.AssociatedValue) -> TokenSyntax
    ) -> FunctionCallExprSyntax {
        FunctionCallExprSyntax(
            calledExpression: MemberAccessExprSyntax(
                period: .periodToken(),
                name: enumCase.name
            ),
            leftParen: enumCase.associatedValues.isEmpty ? nil : .leftParenToken(),
            arguments: .init {
                for associatedValue in enumCase.associatedValues {
                    LabeledExprSyntax(
                        leadingTrivia: .newline,
                        label: associatedValue.name,
                        colon: associatedValue.name == nil ? nil : .colonToken(),
                        expression: FunctionCallExprSyntax(
                            calledExpression: MemberAccessExprSyntax(
                                base: DeclReferenceExprSyntax(baseName: baseName(associatedValue)),
                                period: .periodToken(),
                                name: functionName(associatedValue)
                            ),
                            leftParen: enumCase.associatedValues.isEmpty ? nil : .leftParenToken(),
                            arguments: .init {
                                LabeledExprSyntax(
                                    label: parameterName(associatedValue),
                                    colon: .colonToken(),
                                    expression: DeclReferenceExprSyntax(baseName: parameterValue(associatedValue))
                                )
                            },
                            rightParen: enumCase.associatedValues.isEmpty ? nil : .rightParenToken()
                        )
                    )
                }
            },
            rightParen: enumCase.associatedValues.isEmpty ? nil : .rightParenToken(leadingTrivia: .newline)
        )
    }
}

// MARK: - Enum case
extension PartiallyUpdatableMacro {

    struct EnumCase {
        let name: TokenSyntax
        let associatedValues: [AssociatedValue]
    }
}

// MARK: - Enum case child
extension PartiallyUpdatableMacro.EnumCase {

    struct AssociatedValue {
        let name: TokenSyntax?
        let uniqueName: TokenSyntax
        let type: TypeSyntax

        func uniqueName(prefixedWith prefix: String) -> TokenSyntax {
            .identifier(prefix + "_" + uniqueName.text)
        }
    }
}

// MARK: - Enum case extraction
extension PartiallyUpdatableMacro {

    private static func parseEnumCases(on declaration: EnumDeclSyntax) -> [EnumCase] {

        let caseDeclarations = declaration.memberBlock.members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .flatMap(\.elements)

        let enumCases = caseDeclarations
            .map { element in
                EnumCase(
                    name: element.name.trimmed,
                    associatedValues: parseElementAssociatedValues(element: element)
                )
            }

        return enumCases
    }

    private static func parseElementAssociatedValues(element: EnumCaseElementListSyntax.Element) -> [EnumCase.AssociatedValue] {

        guard let parameters = element.parameterClause?.parameters else {
            return []
        }

        return parameters.enumerated().map { (index, parameter) in

            let parameterName: TokenSyntax
            if let name = parameter.firstName?.text {
                parameterName = "\(raw: element.name.text)_\(raw: name)"
            } else {
                parameterName = "\(raw: element.name.text)_$\(raw: index)"
            }

            return .init(
                name: parameter.firstName,
                uniqueName: parameterName,
                type: parameter.type
            )
        }
    }
}
