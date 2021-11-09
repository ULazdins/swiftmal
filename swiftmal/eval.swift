import Foundation

func eval(_ exp: Expression, environment: Environment) throws -> Expression {
    switch exp {
    case .list(let params):
        if let symbol = try params.first?.getSymbol() {
            switch symbol {
            case "def!":
                return try def(params.dropFirst(0), environment: environment)
            case "let*":
                return try `let`(params.dropFirst(0), environment: environment)
            default:
                return try builtin(symbol, params.dropFirst(0), environment: environment)
            }
        } else {
            return .list(params)
        }
    case .int, .nil, .bool:
        return exp
    case .symbol(let string):
        let symbol = try environment.find(string)
        guard let expression = symbol as? Expression else {
            throw SwiftmalError("`\(symbol)` not an Expression")
        }
        return expression
    }
}

func def(_ params: ArraySlice<Expression>, environment: Environment) throws -> Expression {
    let tail = params.dropFirst()
    
    let (symbol, value) = try tail.extract(
        casePath1: Expression.symbolPath,
        casePath2: Expression.idPath
    )
    
    let evaluated = try eval(value, environment: environment)

    environment.define(symbol, value: evaluated)
    
    return evaluated
}

func `let`(_ params: ArraySlice<Expression>, environment: Environment) throws -> Expression {
    let tail = params.dropFirst()
    
    let (bindings, expression) = try tail.extract(
        casePath1: Expression.listPath,
        casePath2: Expression.idPath
    )
    
    let childEnvironment = Environment(symbolMap: [:], parent: environment)
    
    var pairs: ArraySlice<Expression> = bindings.dropFirst(0)
    while pairs.count > 0 {
        let pair = pairs.prefix(2)
        
        let (symbol, value) = try pair.extract(
            casePath1: Expression.symbolPath,
            casePath2: Expression.idPath
        )
        
        environment.define(
            symbol,
            value: try eval(value, environment: childEnvironment)
        )
        
        pairs = pairs.dropFirst(2)
    }
    
    return try eval(expression, environment: childEnvironment)
}

func builtin(_ symbol: String, _ params: ArraySlice<Expression>, environment: Environment) throws -> Expression {
    let f = try environment.find(symbol)
    
    let tail = Array(params.dropFirst())
    
    let extracted = try tail.extract(
        casePath1: Expression.idPath,
        casePath2: Expression.idPath
    )
    
    guard let f2 = f as? (Int, Int) -> Int else {
        throw SwiftmalError("Not a function")
    }
    
    let int1 = try eval(extracted.0, environment: environment).getInt()
    let int2 = try eval(extracted.1, environment: environment).getInt()
    
    return .int(f2(int1, int2))
}
