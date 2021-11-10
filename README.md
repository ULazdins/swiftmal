# swiftmal
Make A Lisp in swift

This repo follow instructions from https://github.com/kanaka/mal

The goal is to build my first interpreter to get a better understanding of what it takes to make a programming language. I have very little idea of what I'm doing and the code is messier than I'm used to, but "progress, then perfection", right?

Once the minimal language is ready (number and bool data types only and some basic operations with them), the plan is to play around and try different things, like adding the optimization phase (detecting and fixing things like `(* a a) -> (pow a 2)` or `(* a 1) -> a`), adding good error messages pointing at specific character in the input, stricter typing, and other. 

# the plan

- [x] implement basic arithmetics (`+`, `-`, `/`, `*`)
- [x] implement REPL
- [x] implement booleans and `nil`
- [ ] implement flow control operands (`if`, `while`)
- [ ] try and solve some of [Project Euler's](https://projecteuler.net) challenges using this LISP interpreter
