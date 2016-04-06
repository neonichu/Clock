import XCTest
@testable import Clock
import Foundation

func components(year year: Int = 0, month: Int = 0, day: Int = 0,
                     hour: Int = 0, minute: Int = 0, second: Int = 0,
                     timeZoneOffset: NSTimeInterval = 0) -> NSDateComponents {
    let components = NSDateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    components.second = second
    components.timeZone = NSTimeZone(forSecondsFromGMT: Int(timeZoneOffset))
    return components
}

class UTCDatesTests: XCTestCase {
    func testCanParseDates() {
        let expected = components(year: 1971, month: 2, day: 3, hour: 4, minute: 5, second: 6)

        XCTAssertEqual(ISO8601.parse("1971-02-03T04:05:06.789Z"), expected)
        XCTAssertEqual(ISO8601.parse("1971-02-03T04:05:06.78Z"), expected)
        XCTAssertEqual(ISO8601.parse("1971-02-03T04:05:06.7Z"), expected)
        XCTAssertEqual(ISO8601.parse("1971-02-03T04:05:06Z"), expected)
    }

    func testCanParseEpoch() {
        XCTAssertEqual(ISO8601.parse("1970-01-01T00:00:00.000Z"), components(year: 1970, month: 1, day: 1))
    }

    func testCanParseDatesWithoutSeconds() {
        XCTAssertEqual(ISO8601.parse("1971-02-03T04:05Z"), components(year: 1971, month: 2, day: 3, hour: 4, minute: 5))
    }

    func testResilienceAgainstY2KBugs() {
        XCTAssertEqual(ISO8601.parse("2058-02-20T18:29:11.100Z"), components(year: 2058, month: 2, day: 20, hour: 18, minute: 29, second: 11))
        XCTAssertEqual(ISO8601.parse("3001-01-01T08:00:00.000Z"), components(year: 3001, month: 1, day: 1, hour: 8))
    }
}

#if os(Linux)
extension UTCDatesTests: XCTestCaseProvider {
    var allTests : [(String, () throws -> Void)] {
        return [
            ("testCanParseDates", testCanParseDates),
            ("testCanParseEpoch", testCanParseEpoch),
            ("testCanParseDatesWithoutSeconds", testCanParseDatesWithoutSeconds),
            ("testResilienceAgainstY2KBugs", testResilienceAgainstY2KBugs)
        ]
    }
}
#endif
