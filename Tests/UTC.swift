import Spectre
import Clock
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

func describeUTCDates() {
    describe("Parsing of UTC dates") {
        $0.it("can parse dates") {
            let expected = components(year: 1971, month: 2, day: 3, hour: 4, minute: 5, second: 6)

            try expect(ISO8601.parse("1971-02-03T04:05:06.789Z")) == expected
            try expect(ISO8601.parse("1971-02-03T04:05:06.78Z")) == expected
            try expect(ISO8601.parse("1971-02-03T04:05:06.7Z")) == expected
            try expect(ISO8601.parse("1971-02-03T04:05:06Z")) == expected
        }

        $0.it("can parse epoch") {
            try expect(ISO8601.parse("1970-01-01T00:00:00.000Z")) == components(year: 1970, month: 1, day: 1)
        }

        $0.it("can parse dates without seconds") {
            try expect(ISO8601.parse("1971-02-03T04:05Z")) == components(year: 1971, month: 2, day: 3, hour: 4, minute: 5)
        }

        $0.it("is resilient against Y2K bugs") {
            try expect(ISO8601.parse("2058-02-20T18:29:11.100Z")) == components(year: 2058, month: 2, day: 20, hour: 18, minute: 29, second: 11)
            try expect(ISO8601.parse("3001-01-01T08:00:00.000Z")) == components(year: 3001, month: 1, day: 1, hour: 8)
        }
    }
}
