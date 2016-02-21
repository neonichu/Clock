#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

import Foundation

private let GMT_STRING_SIZE = Int(strlen("1971-02-03T09:16:06Z") + 1)

private func epochToISO8601GMTString(epoch : Int) -> String? {
    var epoch = epoch
    var time: UnsafeMutablePointer<tm>
    time = gmtime(&epoch)

    let buffer = UnsafeMutablePointer<Int8>.alloc(GMT_STRING_SIZE)
    strftime(buffer, GMT_STRING_SIZE, "%FT%TZ", time);
    return String.fromCString(buffer)
}

extension NSDate {
    /// Get an ISO8601 compatible string representation
    public func toISO8601GMTString() -> String? {
        let epoch = Int(self.timeIntervalSince1970)
        return epochToISO8601GMTString(epoch)
    }
}

extension tm {
    public func toISO8601GMTString() -> String? {
        var tm_struct = self
        let epoch = Int(timegm(&tm_struct))
        return epochToISO8601GMTString(epoch)
    }
}
