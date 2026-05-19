import SwiftSyntax

extension DeclModifierSyntax {

    var minimumProtocolWitnessVisibilityForAccessModifier: TokenSyntax? {
        switch name.tokenKind {
        case .keyword(.public):
            .keyword(.public)
        case .keyword(.package):
            .keyword(.package)
        case .keyword(.internal):
            .keyword(.internal)
        case .keyword(.fileprivate):
            .keyword(.fileprivate)
        case .keyword(.private):
            .keyword(.fileprivate)
        default:
            nil
        }
    }

    var isNeededAccessLevelModifier: Bool {
        switch name.tokenKind {
        case .keyword(.public):
            true
        case .keyword(.package):
            true
        case .keyword(.internal):
            false
        case .keyword(.fileprivate):
            true
        case .keyword(.private):
            true
        default:
            false
        }
    }

    var isStaticModifier: Bool {
        switch name.tokenKind {
        case .keyword(.static):
            true
        default:
            false
        }
    }
}
