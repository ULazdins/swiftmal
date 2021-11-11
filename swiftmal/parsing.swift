import Foundation
import Parsing

let whitespace = Prefix<Substring>(while: { $0 == " " })

var lisp: AnyParser<Substring, Expression> = Skip(whitespace)
    .take(expression)
    .skip(whitespace)
    .skip(End())
    .eraseToAnyParser()

private var expression: AnyParser<Substring, Expression> {
    int
        .orElse(`nil`)
        .orElse(bool)
        .orElse(list)
        .orElse(symbol)
        .eraseToAnyParser()
}

let int: AnyParser<Substring, Expression> = Int.parser()
    .map(Expression.int)
    .eraseToAnyParser()

let `nil`: AnyParser<Substring, Expression> = Skip(whitespace)
    .skip(StartsWith("nil"))
    .map { _ in Expression.nil }
    .eraseToAnyParser()

let `true`: AnyParser<Substring, Expression> = Skip(whitespace)
    .take(StartsWith("true"))
    .map { _ in Expression.bool(true) }
    .eraseToAnyParser()

let `false`: AnyParser<Substring, Expression> = Skip(whitespace)
    .take(StartsWith("false"))
    .map { _ in Expression.bool(false) }
    .eraseToAnyParser()

let bool: AnyParser<Substring, Expression> = Skip(whitespace)
    .take(`true`.orElse(`false`))
    .eraseToAnyParser()

let symbolCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "+-/*!=<>"))

let string: AnyParser<Substring, Substring> = Prefix<Substring>(
    minLength: 1,
    maxLength: nil,
    while: { (e: Character) in
        let chars = CharacterSet(charactersIn: String(e))
        return symbolCharacterSet.isSuperset(of: chars)
    })
    .eraseToAnyParser()

let symbol: AnyParser<Substring, Expression> = string
    .map({
        Expression.symbol(String($0))
    })
    .eraseToAnyParser()

let list: AnyParser<Substring, Expression> = Skip(whitespace)
    .skip(StartsWith("("))
    .skip(whitespace)
    .take(Many(Lazy{
        expression
    }, separator: whitespace))
    .skip(whitespace)
    .skip(StartsWith(")"))
    .skip(whitespace)
    .map { return Expression.list($0) }
    .eraseToAnyParser()
