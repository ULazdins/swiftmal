import Foundation
import CasePaths

public enum Expression: Equatable {
    indirect case list([Expression])
    case int(Int)
    case `nil`
    case bool(Bool)
    case symbol(String)
    
    func print() -> String {
        switch self {
        case .list(let params):
            return params.map({$0.print()}).joined(separator:" ")
        case .int(let int):
            return "\(int)"
        case .nil:
            return "nil"
        case .bool(let bool):
            return bool ? "true" : "false"
        case .symbol(let string):
            return "\(string)"
        }
    }
}
