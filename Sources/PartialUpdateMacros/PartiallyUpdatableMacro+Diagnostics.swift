import SwiftDiagnostics

extension PartiallyUpdatableMacro {
    enum DiagnosticMessage {

        case notAValueType
        case noTypeAnnotation
    }
}

extension PartiallyUpdatableMacro.DiagnosticMessage: SwiftDiagnostics.DiagnosticMessage {

    var message: String {

        switch self {
        case .notAValueType:
            "Macro \"@PartiallyUpdatable\" can only be applied to a value type."
        case .noTypeAnnotation:
            "Property must include a type annotation to be included in \"@PartiallyUpdatable\" macro."
        }
    }

    private var messageID: String {

        switch self {
        case .notAValueType:
            "notAValueType"
        case .noTypeAnnotation:
            "noTypeAnnotation"
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
        }
    }
}
