import Spectre
import Clock
import Foundation

#if os(Linux)
import Glibc
#endif

func tm_struct(year year: Int = 0, month: Int = 0, day: Int = 0,
    hour: Int = 0, minute: Int = 0, second: Int = 0,
    timeZoneOffset: NSTimeInterval = 0) -> tm {
    return tm(tm_sec: Int32(second), tm_min: Int32(minute), tm_hour: Int32(hour), tm_mday: Int32(day), tm_mon: Int32(month - 1), tm_year: Int32(year - 1900), tm_wday: 0, tm_yday: 0, tm_isdst: 0, tm_gmtoff: Int(timeZoneOffset), tm_zone: nil)
    }

extension tm : Equatable {}

public func ==(lhs: tm, rhs: tm) -> Bool {
	return lhs.tm_sec == rhs.tm_sec && lhs.tm_min == rhs.tm_min && lhs.tm_hour == rhs.tm_hour && lhs.tm_mday == rhs.tm_mday && lhs.tm_mon == rhs.tm_mon && lhs.tm_year == rhs.tm_year && lhs.tm_wday == rhs.tm_wday && lhs.tm_yday == rhs.tm_yday && lhs.tm_isdst == rhs.tm_isdst && lhs.tm_gmtoff == rhs.tm_gmtoff && lhs.tm_zone == rhs.tm_zone
}

func describeTMStruct() {
	describe("Conversion to TM struct") {
	$0.it("can parse dates") {
      let expected = tm_struct(year: 1971, month: 2, day: 3, hour: 9, minute: 16, second: 6, timeZoneOffset: 311 * 60)

      let tm_value: tm = ISO8601.parse("1971-02-03T09:16:06.789+05:11")
      try expect(tm_value) == expected
      }
	}
}
