import SwiftDiagnostics

extension PartiallyUpdatableIgnoredMacro {
    enum DiagnosticMessage {

        case canOnlyBeAppliedToStructProperty
    }
}

extension PartiallyUpdatableIgnoredMacro.DiagnosticMessage: SwiftDiagnostics.DiagnosticMessage {

    var message: String {

        switch self {
        case .canOnlyBeAppliedToStructProperty:
            "Macro \"@PartiallyUpdatableIgnored\" can only be applied to a struct property."
        }
    }

    private var messageID: String {

        switch self {
        case .canOnlyBeAppliedToStructProperty:
            "canOnlyBeAppliedToStructProperty"
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
        case .canOnlyBeAppliedToStructProperty:
            .warning
        }
    }
}
