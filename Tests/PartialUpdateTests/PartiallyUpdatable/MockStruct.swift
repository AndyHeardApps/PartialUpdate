import Foundation
import PartialUpdate

@PartiallyUpdatable
struct MockStruct: Identifiable, Codable {

    // MARK: - Properties
    var int: Int
    var double: Double
    var string: String
    var bool: Bool
    let id: UUID
    var date: Date
    var optionalInt: Int?
    var optionalDouble: Double?
    var optionalString: String?
    var optionalBool: Bool?
    var optionaID: UUID?
    var optionalDate: Date?

    // MARK: - Initializer
    init(
        int: Int = 0,
        double: Double = 0,
        string: String = "",
        bool: Bool = false,
        id: UUID = 0,
        date: Date = .init(timeIntervalSinceReferenceDate: 0),
        optionalInt: Int? = 3,
        optionalDouble: Double? = nil,
        optionalString: String? = nil,
        optionalBool: Bool? = nil,
        optionaID: UUID? = nil,
        optionalDate: Date? = nil
    ) {
        self.int = int
        self.double = double
        self.string = string
        self.bool = bool
        self.id = id
        self.date = date
        self.optionalInt = optionalInt
        self.optionalDouble = optionalDouble
        self.optionalString = optionalString
        self.optionalBool = optionalBool
        self.optionaID = optionaID
        self.optionalDate = optionalDate
    }

    func mutated() -> MockStruct {
        .init(
            int: 2,
            double: 2,
            string: "2",
            bool: true,
            id: id,
            date: .init(timeIntervalSinceReferenceDate: 2),
            optionalInt: nil,
            optionalDouble: 2,
            optionalString: "3",
            optionalBool: false,
            optionalDate: nil
        )
    }
}
