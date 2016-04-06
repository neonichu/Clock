import XCTest
@testable import Clock
import Foundation

class LocaltimeDatesTests: XCTestCase {
    func testParsingOfLocaltimeDates() {
        let expected = components(year: 1971, month: 2, day: 3, hour: 9, minute: 16, second: 6, timeZoneOffset: 311 * 60)

        XCTAssertEqual(ISO8601.parse("1971-02-03T09:16:06.789+05:11"), expected)
        XCTAssertEqual(ISO8601.parse("1971-02-03T09:16:06+05:11"), expected)
        XCTAssertEqual(ISO8601.parse("1971-02-03T09:16:06.7+05:11"), expected)
        XCTAssertEqual(ISO8601.parse("1971-02-03T09:16:06+05:11"), expected)
    }

    func testCanParseDatesWithNegativeTimezoneOffsets() {
        let expected = components(year: 1971, month: 2, day: 3, hour: 9, minute: 16, second: 6, timeZoneOffset: -311 * 60)

        XCTAssertEqual(ISO8601.parse("1971-02-03T09:16:06.789-05:11"), expected)
    }

    func testCanParseTimezoneOffsetsWithoutColons() {
        let expected = components(year: 1971, month: 2, day: 3, hour: 9, minute: 16, second: 6, timeZoneOffset: 311 * 60)

        XCTAssertEqual(ISO8601.parse("1971-02-03T09:16:06.789+0511"), expected)
        XCTAssertEqual(ISO8601.parse("1971-02-03T09:16:06.78+0511"), expected)
        XCTAssertEqual(ISO8601.parse("1971-02-03T09:16:06.7+0511"), expected)
        XCTAssertEqual(ISO8601.parse("1971-02-03T09:16:06+0511"), expected)
    }
}

#if os(Linux)
extension LocaltimeDatesTests: XCTestCaseProvider {
    var allTests : [(String, () throws -> Void)] {
        return [
            ("testParsingOfLocaltimeDates", testParsingOfLocaltimeDates),
            ("testCanParseDatesWithNegativeTimezoneOffsets", testCanParseDatesWithNegativeTimezoneOffsets),
            ("testCanParseTimezoneOffsetsWithoutColons", testCanParseTimezoneOffsetsWithoutColons)
        ]
    }
}
#endif
