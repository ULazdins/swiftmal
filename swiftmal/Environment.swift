class Environment {
    private(set) var symbolMap: [String: Any] = [
        "+": { (a: Int, b: Int) in a + b },
        "-": { (a: Int, b: Int) in a - b },
        "*": { (a: Int, b: Int) in a * b },
        "/": { (a: Int, b: Int) in a / b },
    ]
    
    func define(_ s: String, value: Any) {
        symbolMap[s] = value
    }
    
    static let root = Environment()
}
