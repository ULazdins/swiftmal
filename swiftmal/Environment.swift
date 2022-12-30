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
