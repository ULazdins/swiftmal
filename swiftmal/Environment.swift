struct Environment {
    let symbolMap = [
        "+": { (a: Int, b: Int) in a + b },
        "-": { (a: Int, b: Int) in a - b },
        "*": { (a: Int, b: Int) in a * b },
        "/": { (a: Int, b: Int) in a / b },
    ]
    
    static let root = Environment()
}
