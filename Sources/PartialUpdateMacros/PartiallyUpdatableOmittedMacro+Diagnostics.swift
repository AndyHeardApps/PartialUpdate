import SwiftDiagnostics

extension PartiallyUpdatableOmittedMacro {
    enum DiagnosticMessage {
        case canOnlyBeAppliedToStructProperty
    }
}

extension PartiallyUpdatableOmittedMacro.DiagnosticMessage: SwiftDiagnostics.DiagnosticMessage {

    var message: String {
        switch self {
        case .canOnlyBeAppliedToStructProperty:
            "Macro \"@PartiallyUpdatableOmitted\" can only be applied to a struct property."
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
            domain: "PartiallyUpdatableOmittedMacro",
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
