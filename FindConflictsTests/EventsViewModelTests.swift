//
//  EventsViewModelTests.swift
//  FindConflictsTests
//
//  Created by Art Derkint on 6/12/21.
//

import XCTest
@testable import FindConflicts

final class EventsViewModelTests: XCTestCase {

  func test_whenUnsortedEvents_eventsAreSortedByStartDate() {
    let event1 = Event(title: "Event 1",
                       start: Date.date("10:00 AM"),
                       end: Date.date("12:00 PM"))
    let event2 = Event(title: "Event 2",
                       start: Date.date("8:00 AM"),
                       end: Date.date("10:00 AM"))

    let sut = EventsViewModel(source: MockEventsSource(events: [event1, event2]))

    XCTAssertEqual(sut.sectionedEvents[0].items[0].start.timeIntervalSince1970, 1514793600.0)
    XCTAssertEqual(sut.sectionedEvents[0].items[1].start.timeIntervalSince1970, 1514800800.0)
  }

  func test_whenEventsAreAcrossMultipleDays_eventsAreGroupedInSections() {
    let event1 = Event(title: "Event 1",
                       start: Date.date(year: 2018, month: 1, day: 1, hour: 10, minute: 0),
                       end: Date.date(year: 2018, month: 1, day: 1, hour: 11, minute: 0))
    let event2 = Event(title: "Event 2",
                       start: Date.date(year: 2018, month: 1, day: 2, hour: 10, minute: 0),
                       end: Date.date(year: 2018, month: 1, day: 2, hour: 10, minute: 0))

    let sut = EventsViewModel(source: MockEventsSource(events: [event1, event2]))
    XCTAssertEqual(sut.sectionedEvents[0].headerTitle, "January 1, 2018")
    XCTAssertEqual(sut.sectionedEvents[0].items[0].title, "Event 1")
    XCTAssertEqual(sut.sectionedEvents[1].headerTitle, "January 2, 2018")
    XCTAssertEqual(sut.sectionedEvents[1].items[0].title, "Event 2")
  }

  func test_when2EventsConflict_bothEventsAreConflicting() {
    let event1 = Event(title: "Event 1",
                       start: Date.date("9:00 AM"),
                       end: Date.date("11:00 AM"))
    let event2 = Event(title: "Event 2",
                       start: Date.date("8:00 AM"),
                       end: Date.date("10:00 AM"))

    let sut = EventsViewModel(source: MockEventsSource(events: [event1, event2]))

    XCTAssertTrue(sut.sectionedEvents[0].items[0].hasConflict)
    XCTAssertTrue(sut.sectionedEvents[0].items[1].hasConflict)
  }

  func test_when2EventsNotInConflict_bothEventsAreNotConflicting() {

    let event1 = Event(title: "Event 1",
                       start: Date.date("10:00 AM"),
                       end: Date.date("11:00 AM"))
    let event2 = Event(title: "Event 2",
                       start: Date.date("1:00 PM"),
                       end: Date.date("2:00 PM"))

    let sut = EventsViewModel(source: MockEventsSource(events: [event1, event2]))

    XCTAssertFalse(sut.sectionedEvents[0].items[0].hasConflict)
    XCTAssertFalse(sut.sectionedEvents[0].items[1].hasConflict)
  }

  func test_whenOneEventEndAtTheSameTimeTheNextEventStart_noConflict() {
    let event1 = Event(title: "Event 1",
                       start: Date.date("3:00 PM"),
                       end: Date.date("4:00 PM"))
    let event2 = Event(title: "Event 2",
                       start: Date.date("4:00 PM"),
                       end: Date.date("5:00 PM"))
    let sut = EventsViewModel(source: MockEventsSource(events: [event1, event2]))

    XCTAssertFalse(sut.sectionedEvents[0].items[0].hasConflict)
    XCTAssertFalse(sut.sectionedEvents[0].items[1].hasConflict)
  }

  func test_whenMultipleSeparateConflicts_eventsAreConflicting() {

    let event1 = Event(title: "Event 1",
                       start: Date.date("3:00 PM"),
                       end: Date.date("4:00 PM"))
    let event2 = Event(title: "Event 2",
                       start: Date.date("3:30 PM"),
                       end: Date.date("4:00 PM"))
    let event3 = Event(title: "Event 3",
                       start: Date.date("8:00 PM"),
                       end: Date.date("9:30 PM"))
    let event4 = Event(title: "Event 4",
                       start: Date.date("10:00 PM"),
                       end: Date.date("11:30 PM"))
    let event5 = Event(title: "Event 5",
                       start: Date.date("11:00 PM"),
                       end: Date.date("11:45 PM"))

    let sut = EventsViewModel(source: MockEventsSource(events: [event1, event2, event3, event4, event5]))

    XCTAssertTrue(sut.sectionedEvents[0].items[0].hasConflict)
    XCTAssertTrue(sut.sectionedEvents[0].items[1].hasConflict)
    XCTAssertFalse(sut.sectionedEvents[0].items[2].hasConflict)
    XCTAssertTrue(sut.sectionedEvents[0].items[3].hasConflict)
    XCTAssertTrue(sut.sectionedEvents[0].items[4].hasConflict)
  }

  func test_when3EventsStartAtTheSameTime_allEventsAreConflicting() {

    let event1 = Event(title: "Event 1",
                       start: Date.date("10:00 AM"),
                       end: Date.date("11:00 AM"))
    let event2 = Event(title: "Event 2",
                       start: Date.date("10:00 AM"),
                       end: Date.date("7:00 PM"))
    let event3 = Event(title: "Event 3",
                       start: Date.date("10:00 AM"),
                       end: Date.date("2:00 PM"))

    let sut = EventsViewModel(source: MockEventsSource(events: [event1, event2, event3]))

    XCTAssertTrue(sut.sectionedEvents[0].items[0].hasConflict)
    XCTAssertTrue(sut.sectionedEvents[0].items[1].hasConflict)
    XCTAssertTrue(sut.sectionedEvents[0].items[2].hasConflict)
  }

}

final class MockEventsSource: EventsSourceProtocol {

  let events: [Event]
  init(events: [Event]) {
    self.events = events
  }

  func fetchEvents(completion: @escaping ([Event]) -> Void) {
    completion(events)
  }

}
