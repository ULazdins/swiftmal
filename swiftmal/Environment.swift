class Environment {
    private var symbolMap: [String: Expression]
    private var functions: [Function]
    let parent: Environment?
    
    init(symbolMap: [String: Expression] = [:], functions: [Function] = [], parent: Environment? = nil) {
        self.symbolMap = symbolMap
        self.functions = functions
        self.parent = parent
    }
    
    func define(_ s: String, value: Expression) {
        symbolMap[s] = value
    }
    
    func find(_ s: String) throws -> Expression {
        if let value = symbolMap[s] {
            return value
        }
        
        if let parentValue = try parent?.find(s) {
            return parentValue
        }
        
        throw SwiftmalError("`\(s)` is not defined")
    }
    
    func findFunc(_ s: String) throws -> Function {
        if let f = functions.first(where: { $0.symbol == s }) {
            return f
        }
        
        if let parentValue = try parent?.findFunc(s) {
            return parentValue
        }
        
        throw SwiftmalError("`\(s)` is not defined")
    }
    
    func defineFunc(_ s: String, paramNames: [String], expression: Expression) {
        functions.append(.init(symbol: s, execute: { expressions in
            guard paramNames.count == expressions.count else {
                throw SwiftmalError("Function `\(s)` expects \(paramNames.count) params, but got \(expressions.count)")
            }
            let b = zip(paramNames, expressions).reduce(into: [String: Expression]()) { partialResult, pair in
                partialResult[pair.0] = pair.1
            }
            
            return try eval(expression, environment: Environment(symbolMap: b, parent: self))
        }))
    }
}

extension Environment {
    static func getRoot() -> Environment {
        Environment(
            functions: [
                .fromOne("++", { $0 + 1 }),
                .fromTwo("+", { $0 + $1 }),
                .fromTwo("-", { $0 - $1 }),
                .fromTwo("*", { $0 * $1 }),
                .fromTwo("/", { $0 / $1 }),
                .fromTwo("=", { $0 == $1 }),
                .fromTwo(">", { $0 > $1 }),
                .fromTwo("<", { $0 < $1 }),
                .fromTwo("<=", { $0 <= $1 }),
                .fromTwo(">=", { $0 >= $1 })
            ]
        )
    }
}
