#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

typealias DateTuple = (year: Int, month: Int, day: Int,
    hour: Int, minute: Int, second: Int,
    timezone_hour: Int, timezone_minute: Int)

/// Parser for ISO8601 dates
public struct ISO8601 {
    static let TZ_MINUS_FORMAT = "%04d-%02d-%02dT%02d:%02d:%lf-%02d:%02d"
    static let TZ_MINUS_FORMAT_NO_COLON = "%04d-%02d-%02dT%02d:%02d:%lf-%02d%02d"
    static let TZ_PLUS_FORMAT = "%04d-%02d-%02dT%02d:%02d:%lf+%02d:%02d"
    static let TZ_PLUS_FORMAT_NO_COLON = "%04d-%02d-%02dT%02d:%02d:%lf+%02d%02d"
    static let UTC_FORMAT = "%04d-%02d-%02dT%02d:%02d:%lfZ"

    static func parse(_ dateString: String, withFormat format: String, failAt: Int32 = 5) -> DateTuple? {
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
                    let args: [CVarArg] = [y, m, d, h, mm, s, tz_h, tz_m]
                    withVaList(args) {
                        result = vsscanf(dateString, format, $0)
                    }
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
    func fill(_ dateTuple: DateTuple) -> NSDateComponents {
        self.year = dateTuple.year
        self.month = dateTuple.month
        self.day = dateTuple.day
        self.hour = dateTuple.hour
        self.minute = dateTuple.minute
        self.second = dateTuple.second
        self.timeZone = TimeZone(forSecondsFromGMT: dateTuple.timezone_hour * 60 * 60
            + dateTuple.timezone_minute * 60)
        return self
    }
}

extension tm {
    init(dateTuple: DateTuple) {
        tm_sec = Int32(dateTuple.second)
        tm_min = Int32(dateTuple.minute)
        tm_hour = Int32(dateTuple.hour)
        tm_mday = Int32(dateTuple.day)
        tm_mon = Int32(dateTuple.month - 1)
        tm_year = Int32(dateTuple.year - 1900)
        tm_wday = 0
        tm_yday = 0
        tm_isdst = 0
        tm_gmtoff = dateTuple.timezone_hour * 60 * 60 + dateTuple.timezone_minute * 60
        tm_zone = nil
    }
}

extension ISO8601 {
    private static func parse(_ dateString: String) -> DateTuple {
        for format in [TZ_MINUS_FORMAT, TZ_MINUS_FORMAT_NO_COLON] {
            if let t = parse(dateString, withFormat: format, failAt: 8) {
                return (t.year, t.month, t.day, t.hour, t.minute, t.second, -t.timezone_hour, -t.timezone_minute)
            }
        }

        for format in [TZ_PLUS_FORMAT, TZ_PLUS_FORMAT_NO_COLON] {
            if let dateTuple = parse(dateString, withFormat: format, failAt: 8) {
                return dateTuple
            }
        }

        if let dateTuple = parse(dateString, withFormat: UTC_FORMAT) {
            return dateTuple
        }
        
        return (0,0,0,0,0,0,0,0)
    }
    
    public static func parse(_ dateString: String) -> tm {
        let tuple: DateTuple = parse(dateString)
        return tm(dateTuple: tuple) 
    }
    
    /// Parses an ISO8601 string, returning a coressponding NSDateComponents instance
    public static func parse(_ dateString: String) -> NSDateComponents {
        let components = NSDateComponents()
        let tuple: DateTuple = parse(dateString)
        return components.fill(tuple)
    }
}
