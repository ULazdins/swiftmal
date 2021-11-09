//
//  main.swift
//  swiftmal
//
//  Created by Uģis Lazdiņš on 03/11/2021.
//

import Foundation

func READ(_ s: String) throws -> Expression {
    let result = lisp.parse(s[...])
    
    guard let output = result.output else {
        throw SwiftmalError("Can't parse the expression")
    }
    
    return output
}

func EVAL(_ s: Expression) throws -> Expression {
    return try eval(s)
}

func PRINT(_ s: Expression) -> String {
    return s.print()
}

func rep(_ s: String) throws -> String {
    return PRINT(try EVAL(try READ(s)))
}

while true {
    print("user> ", terminator: "")
    guard let s = readLine() else { break }
    do {
        try print(rep(s))
    } catch(let e) {
        print("Error: \(e)")
    }
}
