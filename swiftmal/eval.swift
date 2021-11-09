import Foundation

struct SwiftmalError: Error {
    private let s: String
    
    var localizedDescription: String {
        s
    }
    
    init(_ s: String) {
        self.s = s
    }
}

func eval(_ exp: Expression) throws -> Expression {
    switch exp {
    case .list(symbol: let symbol, params: let params):
        switch symbol {
        case "def!":
            guard let symbol = try? params.first?.getSymbol() else {
                throw SwiftmalError("`Expecting first parameter of let to be a symbol. Got \(params[0])")
            }
            guard params.count == 2 else {
                throw SwiftmalError("`Expecting to have exactly 2 parameters")
            }
            
            let evaluated = try! eval(params[1])
        
            Environment.root.define(symbol, value: evaluated)
            
            return evaluated
        default:
            guard let f = Environment.root.symbolMap[symbol] else {
                throw SwiftmalError("`\(symbol)` not defined")
            }
            
            guard params.count == 2 else {
                throw SwiftmalError("`\(symbol)` expects 2 parameters, got \(params.count)")
            }
            
            let ints = params.map { param in
                try! eval(param).getInt()
            }
            
            guard let f2 = f as? (Int, Int) -> Int else {
                throw SwiftmalError("Not a function")
            }
            
            return .int(f2(ints[0], ints[1]))
        }
    case .int(let number):
        return .int(number)
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
