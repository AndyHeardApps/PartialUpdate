import SwiftDiagnostics

extension PartiallyUpdatableOmittedMacro {
    enum DiagnosticMessage {

        case cannotBeAppliedToEnum
    }
}

extension PartiallyUpdatableOmittedMacro.DiagnosticMessage: SwiftDiagnostics.DiagnosticMessage {

    var message: String {

        switch self {
        case .cannotBeAppliedToEnum:
            "Macro \"@PartiallyUpdatableOmittedMacro\" can only be applied to a struct property."
        }
    }

    private var messageID: String {

        switch self {
        case .cannotBeAppliedToEnum:
            "cannotBeAppliedToEnum"
        }
    }

    var diagnosticID: MessageID {

        .init(
            domain: "PartiallyUpdatableOmittedMacro",
            id: messageID
        )
    }

    var severity: DiagnosticSeverity {

        switch self {
        case .cannotBeAppliedToEnum:
            .warning
        }
    }
}
