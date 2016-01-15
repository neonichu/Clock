#if os(Linux)
import Glibc
#else
import Darwin
#endif

import Foundation

private let GMT_STRING_SIZE = Int(strlen("1971-02-03T09:16:06Z") + 1)

extension NSDate {
  public func toISO8601GMTString() -> String? {
    var epoch = Int(self.timeIntervalSince1970)
    var time: UnsafeMutablePointer<tm>
    time = gmtime(&epoch)

    let buffer = UnsafeMutablePointer<Int8>.alloc(GMT_STRING_SIZE)
    strftime(buffer, GMT_STRING_SIZE, "%FT%TZ", time);
    return String.fromCString(buffer)
  }
}
