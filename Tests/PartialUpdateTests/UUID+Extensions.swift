import Foundation

extension UUID: @retroactive ExpressibleByIntegerLiteral {

    public init(integerLiteral value: IntegerLiteralType) {
        self.init(uuidString: "00000000-0000-0000-0000-\(String(format: "%012x", value))")!
    }
}
