import Spectre
import Clock
import Foundation

extension NSDateComponents {
    func toDate() -> NSDate {
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        return calendar?.dateFromComponents(self) ?? NSDate()
    }
}

func describeDateToStringConversion() {
    describe("Converting dates to strings") {
        $0.it("can convert TM struct to an ISO8601 GMT string") {
            let actual = tm_struct(year: 1971, month: 2, day: 3, hour: 9, minute: 16, second: 6)

            try expect(actual.toISO8601GMTString()) == "1971-02-03T09:16:06Z"
        }

        #if !os(Linux)
            $0.it("can convert NSDate to an ISO8601 GMT string") {
                let input = components(year: 1971, month: 2, day: 3, hour: 9, minute: 16, second: 6)
                let actual = input.toDate()

                try expect(actual.toISO8601GMTString()) == "1971-02-03T09:16:06Z"
            }
        #endif
    }
}
