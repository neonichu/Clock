import XCTest
@testable import ClockTestSuite

XCTMain([
	testCase(TMStructTests.allTests),
	testCase(DateToStringConversionTests.allTests),
	//testCase(LocaltimeDatesTests.allTests),
	//testCase(UTCDatesTests.allTests),
])
