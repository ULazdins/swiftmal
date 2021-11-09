import Foundation

struct SwiftmalError: Error {
    private let s: String
    
    var localizedDescription: String {
        s
    }
    
    init(_ s: String) {
        self.s = s
    }
}
