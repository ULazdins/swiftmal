import XCTest
import Foundation
import Parsing

class swiftmal_test: XCTestCase {
    func testRead() throws {
        XCTAssertEqual(READ("  123 "), Expression.int(123))
        XCTAssertEqual(READ("  -123 "), Expression.int(-123))
        XCTAssertEqual(READ(" abc   "), Expression.symbol("abc"))
        XCTAssertEqual(READ(" -abc-def   "), Expression.symbol("-abc-def"))
        XCTAssertEqual(READ(" ( abc  ) "), Expression.list(symbol: "abc", params: []))
        XCTAssertEqual(
            READ(" (  abc  def  sss 22 )  "),
            Expression.list(
                symbol: "abc",
                params: [.symbol("def"), .symbol("sss"), .int(22)]
            )
        )
        XCTAssertEqual(
            READ(" ( abc ( aa ) ) "),
            Expression.list(
                symbol: "abc",
                params: [.list(symbol: "aa", params: [])]
            )
        )
        XCTAssertEqual(
            READ("   (d dd 3)"),
            Expression.list(
                symbol: "d",
                params: [.symbol("dd"), .int(3)]
            )
        )
        XCTAssertEqual(
            READ("( + 2 (* 3 4) )"),
            Expression.list(
                symbol: "+",
                params: [
                    .int(2),
                    .list(
                        symbol: "*",
                        params: [
                            .int(3),
                            .int(4)
                        ]
                    )
                ]
            )
        )
    }
    
    func testEval() throws {
        XCTAssertEqual(
            EVAL(
                Expression.list(
                    symbol: "+",
                    params: [.int(2), .int(3)]
                )
            ),
            Expression.int(5)
        )
        XCTAssertEqual(
            EVAL(
                Expression.list(
                    symbol: "+",
                    params: [
                        .int(2),
                        .list(
                            symbol: "*",
                            params: [.int(3), .int(4)]
                        )
                    ]
                )
            ),
            Expression.int(14)
        )
        
        XCTAssertNil(EVAL(Expression.list(symbol: "Z", params: [.int(2), .int(3)])))
        
        XCTAssertEqual(rep("(/ (- (+ 515 (* -87 311)) 296) 27)"), "-994")
    }
}
