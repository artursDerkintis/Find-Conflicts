//
//  EventsViewModel.swift
//  Find Conflicts
//
//  Created by Art Derkint on 6/12/21.
//

import Foundation

/// Events view models taking care of sorting/grouping events and finding conflicting events
final class EventsViewModel: ObservableObject {

  /// Sectioned events by day
  @Published var sectionedEvents: [ListSection<Event>] = []

  /// Events view model constructor
  /// - Parameter source: Events source
  init(source: EventsSourceProtocol) {
    let sortedEvents = sortEvents(source.events)
    let mutatedEvents = findConflicts(sortedEvents)
    sectionedEvents = sectionedEvents(mutatedEvents)
  }

  /// Group events in sections by day
  /// - Parameter events: Array of events
  /// - Returns: Array of sections
  private func sectionedEvents(_ events: [Event]) -> [ListSection<Event>] {

    /// Return early if we have no events
    guard events.count > 0 else { return [] }

    /// Create section array
    var sections: [ListSection<Event>] = []

    /// Create temporary date to later compare with. Initial value is first event's start of day date.
    var temporaryDate: Date = events[0].start.startOfDay

    /// Temporary events array
    var temporaryEvents: [Event] = []

    /// Iterate through all events
    for event in events {

      /// Check if the dates are different
      if temporaryDate != event.start.startOfDay {

        /// Append new section with temporary events array
        sections.append(ListSection<Event>(headerTitle: temporaryDate.monthDayYear, items: temporaryEvents))

        /// Reset to different temporary date
        temporaryDate = event.start.startOfDay

        /// Clear temporary events as we already appended them to sections
        temporaryEvents = []
      }

      /// Add event to temporary events list
      temporaryEvents.append(event)
    }

    /// Add the last temporary events array to the sections after for loop run it's course
    sections.append(ListSection<Event>(headerTitle: temporaryDate.monthDayYear, items: temporaryEvents))

    /// Returns populated sections array
    return sections
  }

  /// Sorts array of events by their start date
  /// - Parameter events: Array of events
  /// - Returns: Sorted array of events
  private func sortEvents(_ events: [Event]) -> [Event] {
    events.sorted(by: { $0.start.timeIntervalSince1970 < $1.start.timeIntervalSince1970 })
  }

  /// Finds conflicting events
  ///
  /// Business requirements asks for an indicator on each event that has conflict with other event.
  /// The simplest path is to iterate through sorted list of events and change each of their `hasConflict` flag accordingly
  ///
  /// - Warning: Events array has to be sorted by `start` for it to work properly
  /// - Parameter events: Sorted array of events
  /// - Returns: Updated array of events where `hasConflict` flag is set accordingly
  /// - Complexity: O(n) where n is amount of events
  private func findConflicts(_ events: [Event]) -> [Event] {

    /// Return early if there's no more than 1 event as it cannot be conflicting
    guard events.count > 1 else { return events }

    /// Make mutable copy of events
    var mutableEvents = events

    /// End timestamp. Initialised with first event's end timestamp.
    var end = mutableEvents[0].end.timeIntervalSince1970

    /// Iterate through all events starting from 2nd item as we have first `end` timestamp in memory
    for i in 1..<mutableEvents.count {

      /// check if there's conflict
      let hasConflict = mutableEvents[i].start.timeIntervalSince1970 < end

      /// check if previous event has no conflict in order not to overwrite it
      if mutableEvents[i - 1].hasConflict == false {
        /// update previous event to reflect conflict state
        mutableEvents[i - 1].hasConflict = hasConflict
      }
      /// update current event to reflect conflict state
      mutableEvents[i].hasConflict = hasConflict

      /// update end to be either current event end time stamp or keep existing one if current event is ending earlier than previous
      /// E.G. previous `1:00 PM - 10:00 PM` - current `2:00 PM - 3:00 PM` = the end stays 10:00 PM
      /// E.G. previous `1:00 PM - 3:00 PM` - current `2:00 PM - 4:00 PM` = the end updates to 4:00 PM
      end = max(events[i].end.timeIntervalSince1970, end)
    }

    /// Return mutated events
    return mutableEvents
  }
}
