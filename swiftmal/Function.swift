import CasePaths

struct Function {
    let symbol: String
    let execute: ([Expression]) throws -> Expression
}

extension Function {
    static func fromTwo(_ symbol: String, _ f: @escaping (Int, Int) -> Int) -> Function {
        Function(symbol: symbol) { expressions in
            let (int1, int2) = try expressions.extract(
                casePath1: /Expression.int,
                casePath2: /Expression.int
            )
            
            return .int(f(int1, int2))
        }
    }
    
    static func fromTwo(_ symbol: String, _ f: @escaping (Int, Int) -> Bool) -> Function {
        Function(symbol: symbol) { expressions in
            let (int1, int2) = try expressions.extract(
                casePath1: /Expression.int,
                casePath2: /Expression.int
            )
            
            return .bool(f(int1, int2))
        }
    }
}
