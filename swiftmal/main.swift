import Foundation

func READ(_ s: String) throws -> Expression {
    let result = lisp.parse(s[...])
    
    guard let output = result.output else {
        throw SwiftmalError("Can't parse the expression")
    }
    
    return output
}

func EVAL(_ s: Expression, environment: Environment) throws -> Expression {
    return try eval(s, environment: environment)
}

func PRINT(_ s: Expression) -> String {
    return s.print()
}

func rep(_ s: String, environment: Environment) throws -> String {
    return PRINT(
        try EVAL(
            try READ(s),
            environment: environment
        )
    )
}

let root = Environment.getRoot()

while true {
    print("user> ", terminator: "")
    guard let s = readLine() else { break }
    do {
        try print(rep(s, environment: root))
    } catch(let e) {
        print("Error: \(e)")
    }
}
