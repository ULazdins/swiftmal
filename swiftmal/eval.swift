import Foundation


func eval(_ exp: Expression) throws -> Expression {
    switch exp {
    case .list(let params):
        if let symbol = try params.first?.getSymbol() {
            switch symbol {
            case "def!":
                let tail = Array(params.dropFirst())
                
                let extracted = try tail.extract(
                    casePath1: Expression.symbolPath,
                    casePath2: Expression.idPath
                )
                
                let evaluated = try eval(extracted.1)
            
                Environment.root.define(extracted.0, value: evaluated)
                
                return evaluated
            default:
                guard let f = Environment.root.symbolMap[symbol] else {
                    throw SwiftmalError("`\(symbol)` not defined")
                }
                
                let tail = Array(params.dropFirst())
                
                let extracted = try tail.extract(
                    casePath1: Expression.idPath,
                    casePath2: Expression.idPath
                )
                
                guard let f2 = f as? (Int, Int) -> Int else {
                    throw SwiftmalError("Not a function")
                }
                
                let int1 = try eval(extracted.0).getInt()
                let int2 = try eval(extracted.1).getInt()
                
                return .int(f2(int1, int2))
            }
        } else {
            return .list(params)
        }
    case .int:
        return exp
    case .symbol(let string):
        guard let symbol = Environment.root.symbolMap[string] else {
            throw SwiftmalError("`\(symbol)` not defined")
        }
        guard let expression = symbol as? Expression else {
            throw SwiftmalError("`\(symbol)` not an Expression")
        }
        return expression
    }
}
