import Foundation
import CasePaths

public enum Expression: Equatable {
    indirect case list([Expression])
    case int(Int)
    case symbol(String)
    
    func print() -> String {
        switch self {
        case .list(let params):
            return params.map({$0.print()}).joined(separator:" ")
        case .int(let int):
            return "\(int)"
        case .symbol(let string):
            return "\(string)"
        }
    }
    
    func getInt() throws -> Int {
        switch self {
        case .int(let int):
            return int
        default:
            throw SwiftmalError("Not an integer")
        }
    }
    
    func getSymbol() throws -> String {
        switch self {
        case .symbol(let symbol):
            return symbol
        default:
            throw SwiftmalError("Not a symbol")
        }
    }
    
    static var intPath = CasePath<Expression, Int>(
        embed: { int in
            Expression.int(int)
        },
        extract: { expression in
          guard
            case let .int(int) = expression else { return nil }
            return int
        }
    )
    static var symbolPath = CasePath<Expression, String>(
        embed: { symbol in
            Expression.symbol(symbol)
        },
        extract: { expression in
          guard
            case let .symbol(symbol) = expression else { return nil }
            return symbol
        }
    )
    static var listPath = CasePath<Expression, [Expression]>(
        embed: { list in
            Expression.list(list)
        },
        extract: { expression in
          guard
            case let .list(list) = expression else { return nil }
            return list
        }
    )
    static var idPath = CasePath<Expression, Expression>(
        embed: { expression in
            expression
        },
        extract: { expression in
            expression
        }
    )
}
