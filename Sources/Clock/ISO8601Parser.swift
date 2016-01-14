#if os(Linux)
import Glibc
#else
import Darwin
#endif

typealias DateTuple = (year: Int, month: Int, day: Int,
    hour: Int, minute: Int, second: Int,
    timezone_hour: Int, timezone_minute: Int)

public struct ISO8601 {
  static let TZ_MINUS_FORMAT = "%04d-%02d-%02dT%02d:%02d:%lf-%02d:%02d"
  static let TZ_MINUS_FORMAT_NO_COLON = "%04d-%02d-%02dT%02d:%02d:%lf-%02d%02d"
  static let TZ_PLUS_FORMAT = "%04d-%02d-%02dT%02d:%02d:%lf+%02d:%02d"
  static let TZ_PLUS_FORMAT_NO_COLON = "%04d-%02d-%02dT%02d:%02d:%lf+%02d%02d"
  static let UTC_FORMAT = "%04d-%02d-%02dT%02d:%02d:%lfZ"

  static func parse(dateString: String, withFormat format: String, failAt: Int32 = 5) -> DateTuple? {
    var y: Int32 = 0
    var m: Int32 = 0
    var d: Int32 = 0
    var h: Int32 = 0
    var mm: Int32 = 0
    var s: Double = 0
    var tz_h: Int32 = 0
    var tz_m: Int32 = 0

    var result: Int32 = 0

    withUnsafeMutablePointers(&y, &m, &d) { y, m, d in
      withUnsafeMutablePointers(&h, &mm, &s) { h, mm, s in
        withUnsafeMutablePointers(&tz_h, &tz_m) { tz_h, tz_m in
          let args: [CVarArgType] = [y, m, d, h, mm, s, tz_h, tz_m]
          result = vsscanf(dateString, format, getVaList(args))
        }
      }
    }

    if result < failAt {
      return nil
    }

    return (Int(y), Int(m), Int(d), Int(h), Int(mm), Int(s), Int(tz_h), Int(tz_m))
  }
}

import Foundation

private extension NSDateComponents {
  func fill(dateTuple: DateTuple) -> NSDateComponents {
    self.year = dateTuple.year
    self.month = dateTuple.month
    self.day = dateTuple.day
    self.hour = dateTuple.hour
    self.minute = dateTuple.minute
    self.second = dateTuple.second
    self.timeZone = NSTimeZone(forSecondsFromGMT: dateTuple.timezone_hour * 60 * 60 
        + dateTuple.timezone_minute * 60)
    return self
  }
}

extension ISO8601 {
  public static func parse(dateString: String) -> NSDateComponents {
    let components = NSDateComponents()

    for format in [TZ_MINUS_FORMAT, TZ_MINUS_FORMAT_NO_COLON] {
      if let t = parse(dateString, withFormat: format, failAt: 8) {
        return components.fill((t.year, t.month, t.day, t.hour, t.minute, t.second,
            -t.timezone_hour, -t.timezone_minute))
      }
    }

    for format in [TZ_PLUS_FORMAT, TZ_PLUS_FORMAT_NO_COLON] {
      if let dateTuple = parse(dateString, withFormat: format, failAt: 8) {
        return components.fill(dateTuple)
      }
    }

    if let dateTuple = parse(dateString, withFormat: UTC_FORMAT) {
      return components.fill(dateTuple)
    }

    return components
  }
}
