import XCTest
import Foundation
import Parsing

class swiftmal_test: XCTestCase {
    func test1() throws {
        let actual = READ("  123 ")
        
        XCTAssertEqual(actual, Expression.int(123))
    }
    
    func test2() throws {
        let actual = READ(" abc   ")
        
        XCTAssertEqual(actual, Expression.string("abc"))
    }
    
    func test3() throws {
        let actual = READ(" ( abc  ) ")
        
        XCTAssertEqual(actual, Expression.list(symbol: "abc", params: []))
    }
    
    func test4() throws {
        let actual = READ(" (  abc  def  sss 22 )  ")
        
        XCTAssertEqual(
            actual,
            Expression.list(
                symbol: "abc",
                params: [.string("def"), .string("sss"), .int(22)]
            )
        )
    }
    
    func test5() throws {
        let actual = READ(" ( abc ( aa ) ) ")
        
        XCTAssertEqual(
            actual,
            Expression.list(
                symbol: "abc",
                params: [.list(symbol: "aa", params: [])]
            )
        )
    }
    
    func test6() throws {
        let actual = READ("   (d dd 3)")
        
        XCTAssertEqual(
            actual,
            Expression.list(
                symbol: "d",
                params: [.string("dd"), .int(3)]
            )
        )
    }
    
 
}
