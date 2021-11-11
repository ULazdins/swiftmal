import Foundation
import CasePaths

func eval(_ exp: Expression, environment: Environment) throws -> Expression {
    switch exp {
    case .list(let params):
        if let first = params.first, let symbol = (/Expression.symbol).extract(from: first) {
            switch symbol {
            case "def!":
                return try def(params.dropFirst(0), environment: environment)
            case "let*":
                return try `let`(params.dropFirst(0), environment: environment)
            case "if":
                let conditionExpression = try params.extract(offset: 1, casePath: /Expression.self)
                
                let conditionResult = try eval(conditionExpression, environment: environment)
                
                if conditionResult != .nil && conditionResult != .bool(false) {
                    let trueExpression = try params.extract(offset: 2, casePath: /Expression.self)
                    return try eval(trueExpression, environment: environment)
                } else {
                    if params.count > 3 {
                        let flseExpression = try params.extract(offset: 3, casePath: /Expression.self)
                        return try eval(flseExpression, environment: environment)
                    } else {
                        return .nil
                    }
                }
                
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
        casePath1: /Expression.symbol,
        casePath2: /Expression.self
    )
    
    let evaluated = try eval(value, environment: environment)

    environment.define(symbol, value: evaluated)
    
    return evaluated
}

func `let`(_ params: ArraySlice<Expression>, environment: Environment) throws -> Expression {
    let tail = params.dropFirst()
    
    let (bindings, expression) = try tail.extract(
        casePath1: /Expression.list,
        casePath2: /Expression.self
    )
    
    let childEnvironment = Environment(symbolMap: [:], parent: environment)
    
    var pairs: ArraySlice<Expression> = bindings.dropFirst(0)
    while pairs.count > 0 {
        let pair = pairs.prefix(2)
        
        let (symbol, value) = try pair.extract(
            casePath1: /Expression.symbol,
            casePath2: /Expression.self
        )
        
        environment.define(
            symbol,
            value: try eval(value, environment: childEnvironment)
        )
        
        pairs = pairs.dropFirst(2)
    }
    
    return try eval(expression, environment: childEnvironment)
}

import CasePaths

func builtin(_ symbol: String, _ params: ArraySlice<Expression>, environment: Environment) throws -> Expression {
    let f = try environment.find(symbol)
    
    let tail = try Array(params.dropFirst()).map {
        try eval($0, environment: environment)
    }
    
    let (int1, int2) = try tail.extract(
        casePath1: /Expression.int,
        casePath2: /Expression.int
    )
    
    if let f2 = f as? (Int, Int) -> Int {
        return .int(f2(int1, int2))
    } else if let f2 = f as? (Int, Int) -> Bool {
        return .bool(f2(int1, int2))
    }
    
    throw SwiftmalError("Not a function")
}
