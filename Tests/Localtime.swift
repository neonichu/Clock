import Spectre
import Clock
import Foundation

func describeLocaltimeDates() {
  describe("Parsing of localtime dates") {
    $0.it("can parse dates") {
      let expected = components(year: 1971, month: 2, day: 3, hour: 9, minute: 16, second: 6, timeZoneOffset: 311 * 60)

      try expect(ISO8601.parse("1971-02-03T09:16:06.789+05:11")) == expected
      try expect(ISO8601.parse("1971-02-03T09:16:06+05:11")) == expected
      try expect(ISO8601.parse("1971-02-03T09:16:06.7+05:11")) == expected
      try expect(ISO8601.parse("1971-02-03T09:16:06+05:11")) == expected
    }

    $0.it("can parse dates with negative timezone offsets") {
      let expected = components(year: 1971, month: 2, day: 3, hour: 9, minute: 16, second: 6, timeZoneOffset: -311 * 60)

      try expect(ISO8601.parse("1971-02-03T09:16:06.789-05:11")) == expected
    }

    $0.it("can parse timezone offsets without colons") {
      let expected = components(year: 1971, month: 2, day: 3, hour: 9, minute: 16, second: 6, timeZoneOffset: 311 * 60)

      try expect(ISO8601.parse("1971-02-03T09:16:06.789+0511")) == expected
      try expect(ISO8601.parse("1971-02-03T09:16:06.78+0511")) == expected
      try expect(ISO8601.parse("1971-02-03T09:16:06.7+0511")) == expected
      try expect(ISO8601.parse("1971-02-03T09:16:06+0511")) == expected
    }
  }
}
