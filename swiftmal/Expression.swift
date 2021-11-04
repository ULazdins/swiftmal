public enum Expression: Equatable {
    indirect case list(symbol: String, params: [Expression])
    case int(Int)
    case symbol(String)
    
    func print() -> String {
        switch self {
        case .list(let symbol, let params):
            return "(\(symbol) \(params.map({$0.print()}).joined(separator:" ")))"
        case .int(let int):
            return "\(int)"
        case .symbol(let string):
            return "\(string)"
        }
    }
}
