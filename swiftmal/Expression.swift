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

extension Expression: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .int(value)
    }
    
    public typealias IntegerLiteralType = Int
}

extension Expression: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .bool(value)
    }
    
    public typealias BooleanLiteralType = Bool
    
}

extension Expression: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: String) {
        self = .symbol(value)
    }
}
