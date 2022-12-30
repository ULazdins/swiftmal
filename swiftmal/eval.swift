import Foundation
import CasePaths

func eval(_ exp: Expression, environment: Environment) throws -> Expression {
    switch exp {
    case .list(let params):
        if let first = params.first, let symbol = (/Expression.symbol).extract(from: first) {
            switch symbol {
            case "def!":
                return try def(params.dropFirst(), environment: environment)
            case "let*":
                return try `let`(params.dropFirst(), environment: environment)
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
            case "map":
                let p = try params.dropFirst().extract(casePath1: /Expression.symbol, casePath2: /Expression.list)
                let f = try environment.findFunc(p.0)
                if case Expression.list(let list) = params[2] {
                    return try .list(list.map({ try f.execute([$0]) }))
                }
                throw SwiftmalError("Param at position 2 is not a list")
            default:
                let f = try environment.findFunc(symbol)
                let tail = try params.dropFirst().map({ try eval($0, environment: environment) })
                return try f.execute(tail)
            }
        } else {
            return .list(params)
        }
    case .int, .nil, .bool:
        return exp
    case .symbol(let string):
        return try environment.find(string)
    }
}

func def(_ params: ArraySlice<Expression>, environment: Environment) throws -> Expression {
    let (symbol, value) = try params.extract(
        casePath1: /Expression.symbol,
        casePath2: /Expression.self
    )
    
    let evaluated = try eval(value, environment: environment)

    environment.define(symbol, value: evaluated)
    
    return evaluated
}

func `let`(_ tail: ArraySlice<Expression>, environment: Environment) throws -> Expression {
    let (bindings, expression) = try tail.extract(
        casePath1: /Expression.list,
        casePath2: /Expression.self
    )
    
    let childEnvironment = Environment(parent: environment)
    
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
