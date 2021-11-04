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
        .orElse(array)
        .orElse(string)
        .eraseToAnyParser()
}

let int: AnyParser<Substring, Expression> = Int.parser()
    .map(Expression.int)
    .eraseToAnyParser()

let string2: AnyParser<Substring, Substring> = Prefix<Substring>(
    minLength: 1,
    maxLength: nil,
    while: { (e: Character) in
        let chars = CharacterSet(charactersIn: String(e))
        return CharacterSet.alphanumerics.isSuperset(of: chars)
    })
    .eraseToAnyParser()

let string: AnyParser<Substring, Expression> = string2
    .map({
        Expression.string(String($0))
    })
    .eraseToAnyParser()

let array: AnyParser<Substring, Expression> = Skip(whitespace)
    .skip(StartsWith("("))
    .skip(whitespace)
    .take(string2)
    .skip(whitespace)
    .take(Many(Lazy{
        expression
    }, separator: whitespace))
    .skip(whitespace)
    .skip(StartsWith(")"))
    .skip(whitespace)
    .map {
        return Expression.list(symbol: String($0), params: $1)
    }
    .eraseToAnyParser()
