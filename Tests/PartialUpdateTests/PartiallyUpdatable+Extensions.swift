import Foundation
import PartialUpdate

extension PartiallyUpdatable where PartialUpdate: Codable {

    func recode(_ update: PartialUpdate?) throws -> PartialUpdate? {

        guard let update else {
            return nil
        }

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(update)
        let decoded = try decoder.decode(PartialUpdate.self, from: data)

        return decoded
    }
}
