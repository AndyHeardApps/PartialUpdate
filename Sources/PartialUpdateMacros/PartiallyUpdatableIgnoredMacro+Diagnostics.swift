import SwiftDiagnostics

extension PartiallyUpdatableIgnoredMacro {
    enum DiagnosticMessage {

        case cannotBeAppliedToEnum
    }
}

extension PartiallyUpdatableIgnoredMacro.DiagnosticMessage: SwiftDiagnostics.DiagnosticMessage {

    var message: String {

        switch self {
        case .cannotBeAppliedToEnum:
            "Macro \"@PartiallyUpdatableIgnored\" can only be applied to a struct property."
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
            domain: "PartiallyUpdatableIgnoredMacro",
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
