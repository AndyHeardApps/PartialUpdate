import SwiftDiagnostics

extension PartiallyUpdatableMacro {
    enum DiagnosticMessage {
        case notAValueType
        case noTypeAnnotation
        case noEnumCases
    }
}

extension PartiallyUpdatableMacro.DiagnosticMessage: SwiftDiagnostics.DiagnosticMessage {

    var message: String {
        switch self {
        case .notAValueType:
            "Macro \"@PartiallyUpdatable\" can only be applied to a value type."
        case .noTypeAnnotation:
            "Property must include a type annotation to be included in \"@PartiallyUpdatable\" macro."
        case .noEnumCases:
            "Enum must have at least one case to use the \"@PartiallyUpdatable\" macro. "
        }
    }

    private var messageID: String {
        switch self {
        case .notAValueType:
            "notAValueType"
        case .noTypeAnnotation:
            "noTypeAnnotation"
        case .noEnumCases:
            "noEnumCases"
        }
    }

    var diagnosticID: MessageID {
        .init(
            domain: "PartiallyUpdatableMacro",
            id: messageID
        )
    }

    var severity: DiagnosticSeverity {
        switch self {
        case .notAValueType:
            .error
        case .noTypeAnnotation:
            .warning
        case .noEnumCases:
            .error
        }
    }
}
