import XCTest
@testable import Clock
import Foundation

extension NSDateComponents {
    func toDate() -> NSDate {
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        return calendar?.date(from: self) ?? NSDate()
    }
}

class DateToStringConversionTests: XCTestCase {
    func testConvertTMStructToAnISO8601GMTString() {
        let actual = tm_struct(year: 1971, month: 2, day: 3, hour: 9, minute: 16, second: 6)

        XCTAssertEqual(actual.toISO8601GMTString(), "1971-02-03T09:16:06Z")
    }

#if !os(Linux)
    func testCanConvertNSDateToAnISO8601GMString() {
        let input = components(year: 1971, month: 2, day: 3, hour: 9, minute: 16, second: 6)
        let actual = input.toDate()

        XCTAssertEqual(actual.toISO8601GMTString(), "1971-02-03T09:16:06Z")
    }
#endif
}

#if os(Linux)
extension DateToStringConversionTests: XCTestCaseProvider {
    var allTests : [(String, () throws -> Void)] {
        return [
            ("testConvertTMStructToAnISO8601GMTString", testConvertTMStructToAnISO8601GMTString),
            ("testCanConvertNSDateToAnISO8601GMString", testCanConvertNSDateToAnISO8601GMString)
        ]
    }
}
#endif
