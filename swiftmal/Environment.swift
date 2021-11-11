class Environment {
    private var symbolMap: [String: Any]
    let parent: Environment?
    
    init(symbolMap: [String: Any] = [:], parent: Environment? = nil) {
        self.symbolMap = symbolMap
        self.parent = parent
    }
    
    func define(_ s: String, value: Any) {
        symbolMap[s] = value
    }
    
    func find(_ s: String) throws -> Any {
        if let value = symbolMap[s] {
            return value
        }
        
        if let parentValue = try parent?.find(s) {
            return parentValue
        }
        
        throw SwiftmalError("`\(s)` is not defined")
    }
}

extension Environment {
    static func getRoot() -> Environment {
        return Environment(symbolMap: [
            "+": { (a: Int, b: Int) in a + b },
            "-": { (a: Int, b: Int) in a - b },
            "*": { (a: Int, b: Int) in a * b },
            "/": { (a: Int, b: Int) in a / b },
            "=": { (a: Int, b: Int) in a == b },
            "<": { (a: Int, b: Int) in a < b },
            ">": { (a: Int, b: Int) in a > b },
            "<=": { (a: Int, b: Int) in a <= b },
            ">=": { (a: Int, b: Int) in a >= b },
        ])
    }
}
