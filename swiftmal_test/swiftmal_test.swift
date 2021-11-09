import XCTest
import Foundation
import Parsing

class swiftmal_test: XCTestCase {
    func testRead() throws {
        XCTAssertEqual(try READ("  123 "), Expression.int(123))
        XCTAssertEqual(try READ("  -123 "), Expression.int(-123))
        XCTAssertEqual(try READ(" abc   "), Expression.symbol("abc"))
        XCTAssertEqual(try READ(" -abc-def   "), Expression.symbol("-abc-def"))
        XCTAssertEqual(try READ(" ( abc  ) "), Expression.list(symbol: "abc", params: []))
        XCTAssertEqual(
            try READ(" (  abc  def  sss 22 )  "),
            Expression.list(
                symbol: "abc",
                params: [.symbol("def"), .symbol("sss"), .int(22)]
            )
        )
        XCTAssertEqual(
            try READ(" ( abc ( aa ) ) "),
            Expression.list(
                symbol: "abc",
                params: [.list(symbol: "aa", params: [])]
            )
        )
        XCTAssertEqual(
            try READ("   (d dd 3)"),
            Expression.list(
                symbol: "d",
                params: [.symbol("dd"), .int(3)]
            )
        )
        XCTAssertEqual(
            try READ("( + 2 (* 3 4) )"),
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
            try EVAL(
                Expression.list(
                    symbol: "+",
                    params: [.int(2), .int(3)]
                )
            ),
            Expression.int(5)
        )
        XCTAssertEqual(
            try EVAL(
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
        
        XCTAssertThrowsError(try EVAL(Expression.list(symbol: "Z", params: [.int(2), .int(3)])))
        
        XCTAssertEqual(try rep("(/ (- (+ 515 (* -87 311)) 296) 27)"), "-994")
    }
    
    func testEnvironment() throws {
        XCTAssertEqual(try rep("(def! x 3)"), "3")
        XCTAssertEqual(try rep("x"), "3")
        XCTAssertEqual(try rep("(def! x 4)"), "4")
        XCTAssertEqual(try rep("x"), "4")
        XCTAssertEqual(try rep("(def! y (+ 1 7))"), "8")
        XCTAssertEqual(try rep("y"), "8")
    }
}
