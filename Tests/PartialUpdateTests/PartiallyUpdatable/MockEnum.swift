import Foundation
import PartialUpdate

@PartiallyUpdatable
enum MockEnum {
    case basic
    case int(Int)
    case pair(string: String?, date: Date?)
    case structs([MockStruct])
}
