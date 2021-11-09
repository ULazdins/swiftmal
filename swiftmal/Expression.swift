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
    
    static var intPath: CasePath<Expression, Int> {
        _intPath
    }
    static var symbolPath: CasePath<Expression, String> {
        _symbolPath
    }
    static var idPath: CasePath<Expression, Expression> {
        _idPath
    }
}

let _intPath = CasePath<Expression, Int>(
  embed: { int in
      Expression.int(int)
  },
  extract: { expression in
    guard
      case let .int(int) = expression else { return nil }
      return int
  }
)
let _symbolPath = CasePath<Expression, String>(
  embed: { symbol in
      Expression.symbol(symbol)
  },
  extract: { expression in
    guard
      case let .symbol(symbol) = expression else { return nil }
      return symbol
  }
)
let _idPath = CasePath<Expression, Expression>(
  embed: { expression in
      expression
  },
  extract: { expression in
      expression
  }
)

extension Array where Element == Expression {
    func extract<T, U>(casePath1: CasePath<Expression, T>, casePath2: CasePath<Expression, U>) throws -> (T, U) {
        if self.count != 2 {
            throw SwiftmalError("`Expecting to have exactly 2 parameters")
        }
        
        guard let t: T = (casePath1).extract(from: self[0]) else {
            throw SwiftmalError("Can't convert \(self[0]), to expected value of \(T.self)")
        }
        guard let u: U = (casePath2).extract(from: self[1]) else {
            throw SwiftmalError("Can't convert \(self[1]), to expected value of \(U.self)")
        }
        
        return (t, u)
    }
}

