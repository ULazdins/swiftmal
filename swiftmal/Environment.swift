class Environment {
    private(set) var symbolMap: [String: Any]
    let parent: Environment?
    
    init(symbolMap: [String: Any] = [:], parent: Environment? = nil) {
        self.symbolMap = symbolMap
        self.parent = parent
    }
    
    func define(_ s: String, value: Any) {
        symbolMap[s] = value
    }
}

extension Environment {
    static let root = Environment(symbolMap: [
        "+": { (a: Int, b: Int) in a + b },
        "-": { (a: Int, b: Int) in a - b },
        "*": { (a: Int, b: Int) in a * b },
        "/": { (a: Int, b: Int) in a / b },
    ])
}
