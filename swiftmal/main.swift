//
//  main.swift
//  swiftmal
//
//  Created by Uģis Lazdiņš on 03/11/2021.
//

import Foundation

func READ(_ s: String) -> Expression? {
    let result = lisp.parse(s[...])
    
    print("in: \(s[...])")
    
    return result.output
}

func EVAL(_ s: Expression?) -> Expression? {
    return try? s.map(eval)
}

func PRINT(_ s: Expression?) -> String {
    return s?.print() ?? "-"
}

func rep(_ s: String) -> String {
    return PRINT(EVAL(READ(s)))
}

while true {
    print("user> ", terminator: "")
    guard let s = readLine() else { break }
    print(rep(s))
}
