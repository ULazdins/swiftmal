import Foundation

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
    
    func getInt() throws -> Int {
        switch self {
        case .int(let int):
            return int
        default:
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Not an integer"])
        }
    }
}
