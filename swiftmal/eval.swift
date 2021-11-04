import Foundation

func eval(_ exp: Expression) throws -> Expression {
    switch exp {
    case .list(symbol: let symbol, params: let params):
        guard let f = Environment.root.symbolMap[symbol] else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "`\(symbol)` not defined"])
        }
        
        guard params.count == 2 else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "`\(symbol)` expects 2 parameters, got \(params.count)"])
        }
        
        let ints = params.map { param in
            try! eval(param).getInt()
        }
        
        return .int(f(ints[0], ints[1]))
    case .int(let number):
        return .int(number)
    case .symbol(let string):
        return .symbol(string)
    }
}
