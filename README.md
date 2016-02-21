# :clock12:

[![Build Status](https://img.shields.io/travis/neonichu/Clock/master.svg?style=flat)](https://travis-ci.org/neonichu/Clock)

Naïve ISO8601 date parser, written in Swift.

:warning: WIP

## Usage

You can parse ISO8601 date strings:

```swift
print(ISO8601.parse("1981-10-28T04:05:06.789Z"))
<NSDateComponents: 0x7fbe61d0f040>
    TimeZone: GMT (GMT) offset 0
    Calendar Year: 1981
    Month: 10
    Day: 28
    Hour: 4
    Minute: 5
    Second: 6
```

You can convert `NSDate` instances to a string:

```swift
print(date.toISO8601GMTString())
1971-02-03T09:16:06Z
```
