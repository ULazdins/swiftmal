import XCTest
import Foundation
import Parsing

class swiftmal_test: XCTestCase {
    func testRead() throws {
        XCTAssertEqual(try READ("  123 "), Expression.int(123))
        XCTAssertEqual(try READ("  -123 "), Expression.int(-123))
        XCTAssertEqual(try READ(" abc   "), Expression.symbol("abc"))
        XCTAssertEqual(try READ(" -abc-def   "), Expression.symbol("-abc-def"))
        XCTAssertEqual(try READ(" ( abc  ) "), Expression.list([.symbol("abc")]))
        XCTAssertEqual(
            try READ(" (  abc  def  sss 22 )  "),
            Expression.list([.symbol("abc"), .symbol("def"), .symbol("sss"), .int(22)])
        )
        XCTAssertEqual(
            try READ(" ( abc ( aa ) ) "),
            Expression.list([.symbol("abc"), .list([.symbol("aa")])])
        )
        XCTAssertEqual(
            try READ("   (d dd 3)"),
            Expression.list([.symbol("d"), .symbol("dd"), .int(3)])
        )
        XCTAssertEqual(
            try READ("( + 2 (* 3 4) )"),
            Expression.list([
                .symbol("+"),
                .int(2),
                .list([
                    .symbol("*"),
                    .int(3),
                    .int(4)
                ])
            ])
        )
    }
    
    func testEval() throws {
        let root = Environment.getRoot()
        
        XCTAssertEqual(
            try EVAL(
                Expression.list([.symbol("+"), .int(2), .int(3)]),
                environment: root
            ),
            Expression.int(5)
        )
        XCTAssertEqual(
            try EVAL(
                Expression.list([
                    .symbol("+"),
                    .int(2),
                    .list([.symbol("*"),.int(3), .int(4)])
                ]),
                environment: root
            ),
            Expression.int(14)
        )
        
        XCTAssertThrowsError(
            try EVAL(
                Expression.list([.symbol("Z"), .int(2), .int(3)]),
                environment: root
            )
        )
        
        XCTAssertEqual(
            try rep("(/ (- (+ 515 (* -87 311)) 296) 27)", environment: root),
            "-994"
        )
    }
    
    func testEnvironment() throws {
        let root = Environment.getRoot()
        
        XCTAssertEqual(try rep("(def! x 3)", environment: root), "3")
        XCTAssertEqual(try rep("x", environment: root), "3")
        XCTAssertEqual(try rep("(def! x 4)", environment: root), "4")
        XCTAssertEqual(try rep("x", environment: root), "4")
        XCTAssertEqual(try rep("(def! y (+ 1 7))", environment: root), "8")
        XCTAssertEqual(try rep("y", environment: root), "8")
    }
    
    func testLet() throws {
        let root = Environment.getRoot()
        
        XCTAssertEqual(try rep("(let* (x 9) x)", environment: root), "9")
        XCTAssertEqual(try rep("(let* (p (+ 2 3) q (+ 2 p)) (+ p q))", environment: root), "12")
        
        XCTAssertEqual(try rep("(def! y (let* (z 7) z))", environment: root), "7")
        XCTAssertEqual(try rep("y", environment: root), "7")
    }
    
    func testNilAndBoolean() throws {
        let root = Environment.getRoot()
        
        XCTAssertEqual(try READ("  nil "), Expression.nil)
        XCTAssertEqual(try rep("nil", environment: root), "nil")
        
        XCTAssertEqual(try READ("  false  "), Expression.bool(false))
        XCTAssertEqual(try rep("false", environment: root), "false")
        
        XCTAssertEqual(try READ("  true  "), Expression.bool(true))
        XCTAssertEqual(try rep("true", environment: root), "true")
    }
    
    func testIf() throws {
        let root = Environment.getRoot()
        
        XCTAssertEqual(try rep("(if true (+ 1 7) (+ 1 8))", environment: root), "8")
        XCTAssertEqual(try rep("(if false (+ 1 7) (+ 1 8))", environment: root), "9")
        XCTAssertEqual(try rep("(if false 5)", environment: root), "nil")
    }
    
    func testComparison() throws {
        let root = Environment.getRoot()
        
        XCTAssertEqual(try rep("(= 2 1)", environment: root), "false")
        XCTAssertEqual(try rep("(= 2 (+ 1 1))", environment: root), "true")
        XCTAssertEqual(try rep("(> 2 1)", environment: root), "true")
        XCTAssertEqual(try rep("(<= (- 4 2) 2)", environment: root), "true")
    }
}
