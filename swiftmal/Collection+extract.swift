import Foundation
import CasePaths

extension Collection where Element == Expression {
    func extract<T>(offset: Int, casePath: CasePath<Expression, T>) throws -> T {
        let index = self.index(self.startIndex, offsetBy: offset)
        let value = self[index]
        
        guard let extracted: T = (casePath).extract(from: value) else {
            throw SwiftmalError("Can't convert \(value.print()), to expected value of \(T.self)")
        }
        
        return extracted
    }
    
    func extract<T, U>(casePath1: CasePath<Expression, T>, casePath2: CasePath<Expression, U>) throws -> (T, U) {
        if self.count != 2 {
            throw SwiftmalError("Expecting to have exactly 2 parameters")
        }
        
        let t: T = try self.extract(offset: 0, casePath: casePath1)
        let u: U = try self.extract(offset: 1, casePath: casePath2)
        
        return (t, u)
    }
    
    func extractSymbols() throws -> [String] {
        return try self.map { expression in
            guard let symbol = (/Expression.symbol).extract(from: expression) else {
                throw SwiftmalError("`\(expression)` is not a symbol!")
            }
            return symbol
        }
    }
}

