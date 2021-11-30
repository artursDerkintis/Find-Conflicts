//
//  EventTests.swift
//  FindConflictsTests
//
//  Created by Art Derkint on 6/12/21.
//

import XCTest
@testable import FindConflicts

final class EventTests: XCTestCase {
  
  func test_whenPassingJsonData_eventModelParses() {
    let data = """
                    {"title": "Evening Picnic", "start": "November 10, 2018 6:00 PM", "end": "November 10, 2018 7:00 PM"}
                    """.data(using: .utf8)!
    let result = try! CustomJSONDecoder().decode(Event.self, from: data)
    
    XCTAssertEqual(result.title, "Evening Picnic")
    XCTAssertEqual(result.start.timeIntervalSince1970, 1541872800.0)
    XCTAssertEqual(result.end.timeIntervalSince1970, 1541876400.0)
  }

  func test_whenIts1200PMto100PM_readableRangeIsOfCorrectFormat() {
    let sut = Event(title: "Event", start: Date.date("12:00 PM"), end: Date.date("1:00 PM"))

    XCTAssertEqual(sut.readableRange, "12:00 PM - 1:00 PM")
  }
  
}
